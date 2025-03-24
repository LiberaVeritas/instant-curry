open Synint
open Printing

(* evaluation & associated machinery *)

module VarSet = Set.Make(String)
let mem = VarSet.mem
let empty = VarSet.empty
let union = VarSet.union
let remove = VarSet.remove

type stuck_reason = ListCaseNonList
                  | ArithNonNats
                  | IfZeroNonNat
                  | ApplyNonFun
                  | BadBoundVar
                  | BadRef
exception Stuck of stuck_reason

let rec fvs (e : tm) : VarSet.t =
  match e with
  | Nil -> empty
  | Cons (x, xs) -> union (fvs x) (fvs xs)
  | ListCase (l, n, x, xs, c) ->  (* TODO: remove x and xs only from c *)
    let varlist = List.map fvs [l; n; c] in
    let free = List.fold_left union empty varlist in
    remove x @@ remove xs @@ free
  | Nat _ -> empty 
  | Plus (t, t') | Minus (t, t') | Times (t, t') -> union (fvs t) (fvs t')
  | If0 (e, z, nz) -> union (fvs e) (union (fvs z) (fvs nz))
  | App (e, e') -> union (fvs e) (fvs e')
  | Fun (x, _, e) -> remove x (fvs e)
  | BVar x | Ref x  | MVar x -> VarSet.singleton x
  | UVar _ -> raise NotImplemented

let ctr = ref 0

let fresh (x : name) : name =
  ctr := !ctr + 1; 
  x ^ (string_of_int !ctr)

(* [x := s] t *)
let rec subst (x : name) (s :tm) (e : tm) : tm = 
  match e with
  | Nil -> Nil
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
  | Minus (e, e') -> Minus (subst x s e, subst x s e')
  | Times (e, e') -> Times (subst x s e, subst x s e')
  | If0 (e, z, nz) -> If0 (subst x s e, subst x s z, subst x s nz)
  | App (e, e') -> App (subst x s e, subst x s e')
  | Fun (y, ty, e) -> 
    if x = y then Fun (y, ty, e)
    else let (y, e) = 
      if mem y (fvs s) then rename y e else (y, e)
    in Fun (y, ty, subst x s e)
  | BVar y -> if x = y then s else BVar y
  | Ref y -> if x = y then s else Ref y
  | MVar y -> if x = y then s else MVar y
  | UVar _ -> raise NotImplemented

and rename (x : name) (e : tm) : (name * tm) = 
  let x' = fresh x in
  (x', subst x (BVar x') e)

type clos = ((string * ty) list * tm)
type env = (string * clos) list
type thms = (string * thm_stmt) list
type constrs = (string * tm) list

let rec eval (env : env) (e : tm) : tm =
  (* print_endline @@ Printing.string_of_tm e ; *)

  let () = Stdio.printf "%s\n" (string_of_tm e) in
  match e with
  (* TODO *)
  | Nil -> Nil
  | Cons (x, xs) -> Cons (eval env x, eval env xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match l with
    | Nil -> eval env n
    | Cons (y, ys) -> eval env @@ subst x y (subst xs ys c)  
    | _ -> raise (Stuck ListCaseNonList)
    end
  | Nat _ as v -> v
  | Plus (e, e') -> 
    begin match eval env e, eval env e' with
    | Nat x, Nat y -> Nat (x + y)
    | _ -> raise (Stuck ArithNonNats)
    end
  | Minus (e, e') -> 
    begin match eval env e, eval env e' with
    | Nat x, Nat y -> Nat (max (x - y) 0)
    | _ -> raise (Stuck ArithNonNats)
    end
  | Times (e, e') -> 
    begin match eval env e, eval env e' with
    | Nat x, Nat y -> Nat (x * y)
    | _ -> raise (Stuck ArithNonNats)
    end
  | If0 (e, z, nz) ->
    begin match eval env e with
    | Nat 0 -> eval env z
    | Nat _ -> eval env nz
    | _ -> raise (Stuck IfZeroNonNat)
    end
  | App (f, e') ->
    begin match eval env f with
    | Fun (x, _, e) -> eval env @@ subst x e' e
    | _ -> raise (Stuck ApplyNonFun)
    end
  | Fun _ as v -> v
  | BVar _ -> raise (Stuck BadBoundVar) (* this should have been substituted by now! *)
  | Ref fn ->
    begin match List.assoc_opt fn env with
    | Some (args, t) -> 
      eval env @@ 
      List.fold_right (fun (x, ty) acc -> Fun (x, ty, acc)) args t
    | None -> raise (Stuck BadRef)
    end
  | UVar _ -> raise NotImplemented (* not totally sure what to do here *)
  | MVar _ as v -> v (* uninterpreted metavariables left as-is *)

exception UnifError

let rec unify (env : env) (cs : constrs) (e : tm) (ue : tm) : constrs =
  let unify = unify env in
  match e, ue with
  | e, UVar x -> begin match List.assoc_opt x cs with
    | Some e' when e = e' -> cs
    | Some _ -> raise UnifError
    | None -> (x, e) :: cs
    end
  | Nil, Nil -> cs (* todo: check types? *)
  | Cons (x, xs), Cons (x', xs') -> 
    let cs = unify cs x x' in
    let cs = unify cs xs xs' in
    cs
  | ListCase (l, n, _, _, c), ListCase (l', n', _, _, c') -> (* todo: deal with a-equivalence *) 
    let cs = unify cs l l' in
    let cs = unify cs n n' in
    let cs = unify cs c c' in
    cs
  | Nat _, Nat _ -> cs
  | Plus (e1, e2), Plus (e1', e2')
  | Minus (e1, e2), Minus (e1', e2')
  | Times (e1, e2), Times (e1', e2')
  | App (e1, e2), App (e1', e2') ->
    let cs = unify cs e1 e2 in
    let cs = unify cs e1' e2' in
    cs
  | If0 (n, z, s), If0 (n', z', s') ->
    let cs = unify cs n n' in
    let cs = unify cs z z' in
    let cs = unify cs s s' in
    cs
  | Fun (_, _, b), Fun (_, _, b') ->
    unify cs b b'
  | BVar _, BVar _ -> raise NotImplemented
  | Ref x, Ref y when x = y -> cs
  | MVar _, MVar _ -> raise NotImplemented
  | _, _ -> raise UnifError

let eval_step (thms : thms) (env : env) (e1 : tm) (e2 : tm) (j : justification) : bool = 
  match j with
  | ByDefinition -> eval env e1 = eval env e2
  | ByTheorem t -> 
    let stmt = List.assoc t thms in
    let f = (fun c (x, _) -> subst x (UVar x) c) in
    let claim_lhs = List.fold_left f stmt.claim.eqn.lhs stmt.quantifiers in
    let claim_rhs = List.fold_left f stmt.claim.eqn.rhs stmt.quantifiers in

    claim_lhs = claim_rhs

let exec_stmt (env : env) (s : stmt) : env =
  match s with
  | Print tm -> print_endline @@ string_of_tm @@ eval env tm; env
  | Definition d -> 
    (d.name, (d.args, d.body)) :: env (* TODO: make this CBV *)
  | Thm {name; stmt; proof=_;} -> 
    let env' = (name, (stmt.quantifiers, Nil)) :: env in
    (*Theorem.eval_thm env' stmt proof;*)
    env'
    
let exec_prog (p : program) : env =
  List.fold_left (fun env stmt  -> exec_stmt env stmt ) [] p

