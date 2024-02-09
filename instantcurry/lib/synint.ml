exception NotImplemented

type name = string
type uv_name = string

type ty =
  | Ty_Nat
  | Ty_Arrow of ty * ty
  | Ty_List of ty

(* Terms in the object language. *)
type tm =
  | Nil of ty
  | Cons of tm * tm
  | ListCase of tm (* scrutinee *) * tm (* nil case *) * name * name * tm (* cons case (and its two bound vars) *)
  | Nat of int
  | Plus of tm * tm
  | If0 of tm (* scrutinee *) * tm (* zero case *) * tm (* successor case *)
  | App of tm * tm
  | Fun of name * ty * tm (* anonymous function *)
  | FunRec of name * name * ty * tm (* named, implicitly recursive function *)
  | BVar of name (* A bound variable *)
  | Ref of name (* A free variable, e.g. a self-reference in a recursive function. *)
  | UVar of uv_name (* A unification variable *)
  | MVar of name
    (* A meta variable, referring to a quantified variable in the metalanguage. *)

let (++) a b = App (a, b)

type eqn = { lhs : tm; rhs : tm }

type stmt = {
  quantifiers : name list; (* variables universally quantified in the statement *)
  claim : eqn (* that the LHS = the RHS *)
}
(* ^ Morally this is a nested Pi-type of all the quantified names followed by an equation.
   This is essentially the syntax of types of the metalanguage. *)

(* IMPORTANT: the metalanguage does not really have a syntax of terms for now. *)

type justification =
    | ByDefinition (* To think about: how to specify which definition exactly? *)
    (* TODO add other ones *)

type side = (tm * justification) list

type case = {
    var : name;
    pattern : tm;
    ihs : eqn list;
    wts : eqn;
    lhs : side;
    rhs : side;
}

type proof = name * case list (* Induction variable, cases *)

type thm = {
    name : string;
    stmt : stmt;
    proof : proof;
}

type program = thm list

(* typechecking *)

exception IllTyped
type ctx = (name * ty) list

let rec typecheck (ctx : (name * ty) list) (e : tm) : ty =
  match e with
  | Nil ty -> Ty_List ty
  | Cons (x, xs) -> 
    let ty = typecheck ctx x in
    if typecheck ctx xs = Ty_List ty
      then Ty_List ty else raise IllTyped
  | ListCase (l, n, x, xs, c) -> 
    begin match typecheck ctx l with
    | Ty_List t as lt -> 
      let nt = typecheck ctx n in
      if typecheck ((x, t) :: (xs, lt) :: ctx) c = nt
        then nt
        else raise IllTyped
    | _ -> raise IllTyped
    end
  | Nat _ -> Ty_Nat
  | Plus (e, e') -> 
    if typecheck ctx e = Ty_Nat && typecheck ctx e' = Ty_Nat
      then Ty_Nat else raise IllTyped
  | If0 (e, z, nz) ->
    let ty = typecheck ctx z in
    if typecheck ctx e = Ty_Nat && ty = typecheck ctx nz
      then ty else raise IllTyped
  | App (e, e') ->
    begin match typecheck ctx e with
    | Ty_Arrow (t, t') -> 
      if typecheck ctx e' = t 
        then t' else raise IllTyped
    | _ -> raise IllTyped
    end
  | Fun (x, t, e) ->
    typecheck ((x, t) :: ctx) e
  | FunRec _ -> raise NotImplemented
  | BVar x -> begin try List.assoc x ctx with
    | Not_found -> raise IllTyped end
  | UVar _ -> raise NotImplemented
  | MVar _ -> raise NotImplemented
  | Ref _ -> raise NotImplemented 

(* evaluation & associated machinery *)

module VarSet = Set.Make(String)
let mem = VarSet.mem
let empty = VarSet.empty
let union = VarSet.union
let remove = VarSet.remove

type stuck_reason = ListCaseNonList
                  | AddNonNats
                  | IfZeroNonNat
                  | ApplyNonFun
                  | BadBoundVar
exception Stuck of stuck_reason

let rec fvs (e : tm) : VarSet.t =
  match e with
  | Nil _ -> empty
  | Cons (x, xs) -> union (fvs x) (fvs xs)
  | ListCase (l, n, x, xs, c) ->  (* TODO: remove x and xs only from c *)
    let varlist = List.map fvs [l; n; c] in
    let free = List.fold_left union empty varlist in
    remove x @@ remove xs @@ free
  | Nat _ -> empty 
  | Plus (t, t') -> union (fvs t) (fvs t')
  | If0 (e, z, nz) -> union (fvs e) (union (fvs z) (fvs nz))
  | App (e, e') -> union (fvs e) (fvs e')
  | Fun (x, _, e) -> remove x (fvs e)
  | FunRec (f, x, _, e) -> remove f @@ remove x (fvs e)
  | BVar x -> VarSet.singleton x
  | _ -> raise NotImplemented

let ctr = ref 0

let fresh (x : name) : name =
  ctr := !ctr + 1; 
  x ^ (string_of_int !ctr)

let rec subst (x : name) (s :tm) (e : tm) : tm = (* [x := s] t *)
  match e with
  | Nil ty -> Nil ty
  | Cons (y, ys) -> Cons (subst x s y, subst x s ys)
  | ListCase (l, n, y, ys, c) -> 
    let l' = subst x s l in
    let n' = subst x s n in
    if x = y || x = ys then ListCase (l', n', y, ys, c)
    else let (y, c) =
      if mem y (fvs s) then rename y c else (y, c)
    in let (ys, c) =
      if mem ys (fvs s) then rename ys c else (ys, c)
    in ListCase (l', n', y, ys, subst x s c)
  | Nat i -> Nat i
  | Plus (e, e') -> Plus (subst x s e, subst x s e')
  | If0 (e, z, nz) -> If0 (subst x s e, subst x s z, subst x s nz)
  | App (e, e') -> App (subst x s e, subst x s e')
  | Fun (y, ty, e) -> 
    if x = y then Fun (y, ty, e)
    else let (y, e) = 
      if mem y (fvs s) then rename y e else (y, e)
    in Fun (y, ty, subst x s e)
  | FunRec (f, y, ty, e) ->
    if x = f || x = y then FunRec (f, y, ty, e)
    else let (f, e) =
      if mem f (fvs s) then rename f e else (f, e)
    in let (y, e) =
      if mem y (fvs s) then rename y e else (y, e)
    in FunRec (f, y, ty, subst x s e)
  | BVar y -> if x = y then s else BVar y
  | _ -> raise NotImplemented

and rename (x : name) (e : tm) : (name * tm) = 
  let x' = fresh x in
  (x', subst x (BVar x') e)

let rec eval (e : tm) : tm =
  match e with
  | Nil _ as v -> v
  | Cons (x, xs) -> Cons (eval x, eval xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match l with
    | Nil _ -> eval n
    | Cons (y, ys) -> eval @@ subst x y (subst xs ys c)  
    | _ -> raise (Stuck ListCaseNonList)
    end
  | Nat _ as v -> v
  | Plus (e, e') -> 
    begin match eval e, eval e' with
    | Nat x, Nat y -> Nat (x + y)
    | _ -> raise (Stuck AddNonNats)
    end
  | If0 (e, z, nz) ->
    begin match eval e with
    | Nat 0 -> eval z
    | Nat _ -> eval nz
    | _ -> raise (Stuck IfZeroNonNat)
    end
  | App (f, e') ->
    begin match eval f with
    | Fun (x, _, e) -> eval @@ subst x e' e
    | FunRec (f, x, _, e) as r -> eval @@ subst f r (subst x e' e)
    | _ -> raise (Stuck ApplyNonFun)
    end
  | Fun _ as v -> v
  | FunRec _ as v -> v
  | BVar _ -> raise (Stuck BadBoundVar) (* this should have been substituted by now! *)
  | Ref _ | UVar _ -> raise NotImplemented (* not totally sure what to do here *)
  | MVar _ as v -> v (* uninterpreted metavariables left as-is *)

let unify (e1 : tm) (e2 : tm) (j : justification) : bool = 
  match j with
  | ByDefinition -> eval e1 = eval e2

