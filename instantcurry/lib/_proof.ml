open Synint


open Printing
open Printf
open List

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


let fold_expr (f : tm -> 'a -> 'a) (init : 'a) (expr : tm) =
  let rec fold f e acc =
    match e with
    | App (e1, e2) | Times (e1, e2)
    | Minus (e1, e2) | Plus (e1, e2)
    | Cons (e1, e2) | MApp (e1, e2) -> 
      fold f e1 acc |> fold f e2
    | ListCase (_, n, _, _, c) -> fold f n acc |> fold f c
    | If0 (_, n, y) -> fold f n acc |> fold f y
    | Fun (_, _typ, e') -> fold f e' acc
    | Nil | Nat _
    | BVar _ | Ref _ | MRef _
    | UVar _ | MVar _ 
      -> f e acc
  in
  fold f expr init

let filter_expr (f : tm -> bool) (expr : tm) =
  let f' tm acc =
    if f tm then tm::acc else acc
  in
  fold_expr f' [] expr


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
  | MApp (e, e') -> MApp (subst x s e, subst x s e')
  | Fun (y, ty, e) -> 
    if x = y then Fun (y, ty, e)
    else let (y, e) = 
      if mem y (fvs s) then rename y e else (y, e)
    in Fun (y, ty, subst x s e)
  | BVar y -> if x = y then s else BVar y
  | Ref y -> if x = y then s else Ref y
  | MRef y -> if x = y then s else Ref y
  | MVar y -> if x = y then s else MVar y
  | UVar y -> if x = y then s else UVar y (*raise NotImplemented*)

and rename (x : name) (e : tm) : (name * tm) = 
  let x' = fresh x in
  (x', subst x (BVar x') e)

let list_of_sexp = Core.list_of_sexp
let string_of_sexp = Core.string_of_sexp
let sexp_of_list = Core.sexp_of_list
let sexp_of_string = Core.sexp_of_string


type clos = ((string * ty) list * tm) [@@deriving sexp]
type env = (string * clos) list [@@deriving sexp]
type thms = (string * thm_stmt) list [@@deriving sexp]
type constrs = (string * tm) list [@@deriving sexp]
type ihs = (string * eqn) list [@@deriving sexp]


(* equality of terms, up to generalized variables, and MApp *)
let rec tm_eq e1 e2 =
  let ( $= ) = tm_eq in
  match e1, e2 with
  | Nil, Nil -> true
  | Cons (x, xs), Cons (y, ys) -> 
    x $= y && xs $= ys
  | ListCase (l, n, x, xs, c), ListCase (l', n', y, ys, c') -> 
    String.equal x y &&
    String.equal xs ys &&
    (l  $=  l') &&
    (n  $=  n') &&
    (c  $=  c')
  | Nat n, Nat m -> n = m
  | Plus (a1, a2), Plus (b1, b2)
  | Minus (a1, a2), Minus (b1, b2)
  | Times (a1, a2), Times (b1, b2) 
  | App (a1, a2), App (b1, b2)
  | MApp (a1, a2), MApp (b1, b2)
  | App (a1, a2), MApp (b1, b2)
  | MApp (a1, a2), App (b1, b2) ->
    a1 $= b1 && 
    a2 $= b2
  | If0 (e, z, nz), If0 (e', z', nz') ->
    e $= e' && 
    z $= z' && 
    nz $= nz'
  | Fun (f, _ty, e), Fun (g, _ty', e') -> 
    String.equal f g &&
    e $= e'
  | BVar x, BVar y -> String.equal x y
  | Ref x, Ref y -> String.equal x y
  | MRef x, MRef y -> String.equal x y
  | Ref x, MRef y -> String.equal x y
  | MRef x, Ref y -> String.equal x y
  | MVar x, MVar y -> String.equal x y
  | UVar _, _ -> true
  | _, UVar _ -> true
  | _ -> false

let ( $= ) = tm_eq

(*
find all instances of `from` in `within` and 
replace with `into`
*)
let subst_expr from into within =
  if from = within then into else
  let rec sub e =
    match e with
    | Nil -> if from = Nil then into else Nil
    | Cons (x, xs) -> Cons (sub x, sub xs)
    | ListCase (l, n, x, xs, c) -> 
      ListCase (l, sub n, x, xs, sub c)
    | Nat n -> if from = (Nat n) then into else (Nat n)
    | Plus (e, e') -> Plus (sub e, sub e')
    | Minus (e, e') -> Minus (sub e, sub e')
    | Times (e, e') -> Times (sub e, sub e')
    | If0 (e, z, nz) -> If0 (sub e, sub z, sub nz)
    | App (f, e') -> App (sub f, sub e')
    | MApp (f, e') -> MApp (sub f, sub e')
    | Fun (f, ty, e) -> 
      if from = (Fun (f, ty, e)) then into else (Fun (f, ty, e))
    | BVar v -> if from = (BVar v) then into else (BVar v)
    | Ref v -> if from = (Ref v) then into else (Ref v)
    | MRef v -> if from = (MRef v) then into else (MRef v)
    | UVar v -> if from = (UVar v) then into else (UVar v)
    | MVar v -> if from = (MVar v) then into else (MVar v)
  in
  sub within

(* only substitutes the first matching subtree found *)
let subst_first_expr from into within : tm =
  if from $= within then into else
  let rec sub e =
    match e with
    | Nil -> if from $= Nil then into else Nil
    | Cons (x, xs) -> 
      if from $= x then Cons (into, xs) else
      if from $= xs then Cons (x, into) else
      let res = sub x in
      if not (res = x) then Cons (res, xs) else
      Cons (x, sub xs)
    | ListCase (l, n, x, xs, c) -> 
      if from $= n then ListCase (l, into, x, xs, c) else
      if from $= c then ListCase (l, n, x, xs, into) else
      let res = sub n in
      if not (res = n) then ListCase (l, res, x, xs, c) else
      ListCase (l, sub n, x, xs, sub c)
    | Nat n -> if from $= (Nat n) then into else (Nat n)
    | Plus (e, e') -> 
      if from $= e then Plus (into, e') else
      if from $= e' then Plus (e, into) else
      let res = sub e in
      if not (res = e) then Plus (res, e') else
      Plus (e, sub e')
    | Minus (e, e') -> 
      if from $= e then Minus (into, e') else
      if from $= e' then Minus (e, into) else
      let res = sub e in
      if not (res = e) then Minus (res, e') else
      Minus (sub e, sub e')
    | Times (e, e') -> 
      if from $= e then Times (into, e') else
      if from $= e' then Times (e, into) else
      let res = sub e in
      if not (res = e) then Times (res, e') else
      Times (sub e, sub e')
    | If0 (e, z, nz) -> 
      if from $= e then If0 (into, z, nz) else
      if from $= z then If0 (e, into, nz) else
      if from $= nz then If0 (e, z, into) else
      let res = sub e in
      if not (res = e) then If0 (res, z, nz) else
      let res = sub z in 
      if not (res = z) then If0 (e, res, nz) else
      If0 (e, z, sub nz)
    | App (f, e') -> 
      if from $= f then App (into, e') else
      if from $= e' then App (f, into) else
      let res = sub f in
      if not (res = f) then App (res, e') else
      App (f, sub e')
    | MApp (a, b) -> MApp (a, b)
    | Fun (f, ty, e) -> 
      Fun (f, ty, sub e)
    | BVar v -> if from = (BVar v) then into else (BVar v)
    | MRef r -> 
    printf "\n MRef \n";
      (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e));
      printf "\n\nFROM\n";
      (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm from));
      (*printf "\n\n MRef %s\n\n" r;
      printf "FROM\n";
      (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm from));
      printf "\n\n equals\n";
      (Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_bool (from = (MRef r))));
      printf "\n\n";*)
      begin match from with
      | MRef r' -> 
        printf "\n equals?\n";
        (Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_bool (String.equal r r')));
      printf "\n\n";
      if String.equal r r' then into else (MRef r) (* not equality up to MRef! *)
      | _ -> MRef r
      end


    | Ref v -> 
      (*printf "\n Ref \n";
      (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e));
      printf "\n\nFROM\n";
      (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm from));*)
      begin match from with
      | Ref v' -> 
        (*printf "\n equals?\n";
        (Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_bool (String.equal v v')));
      printf "\n\n";*)
      if String.equal v v' then into else (Ref v) (* not equality up to MRef! *)
      | _ -> Ref v
      end
    | UVar x -> UVar x
    | MVar v -> if from = (MVar v) then into else (MVar v)
  in
  sub within


(* to normal form given env *)
let rec eval (env : env) (e : tm) : tm =
(*printf "eval\n";
(Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e));
  printf "\n\n";*)
  match e with
  | Nil -> Nil
  | Cons (x, xs) -> Cons (eval env x, eval env xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match l with
    | Nil -> eval env n
    | MVar _ -> c
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
  | MApp _ -> e
  | App (f, e') ->
    begin match f with
    | Fun (x, _, e) -> eval env @@ subst x e' e
   (*| Ref r -> eval env @@ App ((apply_def env (Ref r) f), eval env e')*)
    | _ -> eval env @@ App (eval env f, eval env e')
   (* | Ref _ -> eval env @@ App (eval env f
    | MVar _ -> e
    | App (e1, e2) -> App (eval env e1, eval env e2)
    (*| App _ as sub -> eval env (App ((eval env sub), e'))*)
    | _ -> raise (Stuck ApplyNonFun)*)
    end
  | Fun _ as v -> v
  | BVar _ -> raise (Stuck BadBoundVar) (* this should have been substituted by now! *)
  | MRef _ -> e
  | Ref fn -> 
    begin match assoc_opt fn env with
    | Some (args, t) -> 
      eval env @@ 
      fold_right (fun (x, ty) acc -> Fun (x, ty, acc)) args t
    | None -> raise (Stuck BadRef)
    end
  | UVar _ -> raise NotImplemented (* not intotally sure what into do here *)
  | MVar _ as v -> v (* uninterpreted metavariables left as-is *)


let subst_eqn name s (eqn : eqn) = {
    lhs = subst name s eqn.lhs;
    rhs = subst name s eqn.rhs
}

(* check equality in parallel until mismatch, then apply check *)
let rec at_mismatch (check : env -> tm -> tm -> bool) env e1 e2 : bool =
  let eq = at_mismatch check env in
  let ( @= ) = eq in
  printf "parallel\n";
  Core.Sexp.output_hum Stdio.stdout @@ sexp_of_tm e1;
  printf "\n";
  Core.Sexp.output_hum Stdio.stdout @@ sexp_of_tm e2;
  printf "\n\n";
  match e1, e2 with
  | Nil, Nil -> true
  | Cons (x, xs), Cons (y, ys) -> 
    if not (x = y) then check env x y && xs = ys
    else xs @= ys
  | ListCase (_, n, _, _, c), ListCase (_, n', _, _, c') -> 
    if not (n = n') then check env n n' && c = c'
    else c @= c'
  | Nat n, Nat m -> n = m
  | Plus (a1, a2), Plus (b1, b2)
  | Minus (a1, a2), Minus (b1, b2)
  | Times (a1, a2), Times (b1, b2) 
  | App (a1, a2), App (b1, b2) -> 
    if not (a1 = b1) then check env a1 b1 && a2 = b2
    else a2 @= b2
  | MApp (a1, a2), MApp (b1, b2) -> 
    if not (a1 = b1) then check env a1 b1 && a2 = b2
    else a2 @= b2
  | If0 (e, z, nz), If0 (e', z', nz') ->
    if not (e = e') then check env e e' && z = z' && nz = nz'
    else if not (z = z') then check env z z' && nz = nz'
    else nz @= nz'
  | Fun (f, _ty, e), Fun (g, _ty', e') -> 
    String.equal f g &&
    (if not (e = e') then check env e e'
    else true)
  | BVar x, BVar y -> String.equal x y
  | Ref x, Ref y -> String.equal x y
  | MRef x, MRef y -> String.equal x y
  | UVar x, UVar y -> String.equal x y
  | MVar x, MVar y -> String.equal x y
  | _ -> check env e1 e2


(* restore MApp to App and MRef to Ref *)
let restore e =
  let rec res e =
    match e with
    | Nil -> Nil
    | Cons (x, xs) -> Cons (res x, res xs)
    | ListCase (l, n, x, xs, c) -> 
      ListCase (l, res n, x, xs, res c)
    | Nat n -> Nat n
    | Plus (e, e') -> Plus (res e, res e')
    | Minus (e, e') -> Minus (res e, res e')
    | Times (e, e') -> Times (res e, res e')
    | If0 (e, z, nz) -> If0 (res e, res z, res nz)
    | App (f, e') | MApp (f, e') -> App (res f, res e')
    | Fun (f, ty, e) -> 
      Fun (f, ty, res e)
    | BVar v -> BVar v
    | Ref v | MRef v -> Ref v
    | UVar v -> UVar v
    | MVar v -> MVar v
  in
  res e

let check_commonsense env prev curr : bool =
  let prev = restore prev in
  let curr = restore curr in
  
  if (prev = curr) then true else
  match prev, curr with
  | Plus (Nat 0, e), _ -> 
    printf "(add 0)\n"; 
    curr = e
  | Plus (e, Nat 0), _ -> 
    printf "(add 0)\n";
    curr = e
  (* associativity *)
  | Plus (Plus (a1, a2), a3), Plus (b1, Plus (b2, b3))
  | Plus (a1, Plus (a2, a3)), Plus (Plus (b1, b2), b3)
  | Times (a1, Times (a2, a3)), Times (Times (b1, b2), b3)
  | Times (Times (a1, a2), a3), Times (b1, Times (b2, b3)) 
  | App (App (a1, a2), a3), App (b1, App (b2, b3)) 
  | App (a1, App (a2, a3)), App (App (b1, b2), b3) ->
    printf "(assoc)\n";
    a1 = b1 && 
    a2 = b2 && 
    a3 = b3
  (* commutativity *)
  | Plus (a1, a2), Plus (b1, b2)
  | Times (a1, a2), Times (b1, b2) -> 
    printf "(commut)\n";
    a1 = b2 && 
    a2 = b1
  | _ -> (curr = eval env prev)

let rec eval_def (env : env) (def : tm) (e : tm) : tm =
printf "eval with def %s\n" (string_of_tm def);
(Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e));
  printf "\n\n";
  match e with
  | Ref fn | MRef fn ->
    if def = (Ref fn) then
    begin match assoc_opt fn env with
    | Some (args, t) -> 
      eval_def env def @@ 
      fold_right (fun (x, ty) acc -> Fun (x, ty, acc)) args t
    | None -> raise (Stuck BadRef)
    end
    else e
  | Nil -> Nil
  | Cons (x, xs) -> Cons (eval_def env def x, eval_def env def xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match l with
    | Nil -> eval_def env def n
    | MVar _ -> e
    | Cons (y, ys) -> eval_def env def @@ subst x y (subst xs ys c)  
    | _ -> raise (Stuck ListCaseNonList)
    end
  | Nat _ as v -> v
  | Plus (e, e') -> 
    begin match eval_def env def e, eval_def env def e' with
    | Nat x, Nat y -> Nat (x + y)
    | _ -> raise (Stuck ArithNonNats)
    end
  | Minus (e, e') -> 
    begin match eval_def env def e, eval_def env def e' with
    | Nat x, Nat y -> Nat (max (x - y) 0)
    | _ -> raise (Stuck ArithNonNats)
    end
  | Times (e, e') -> 
    begin match eval_def env def e, eval_def env def e' with
    | Nat x, Nat y -> Nat (x * y)
    | _ -> raise (Stuck ArithNonNats)
    end
  | If0 (e, z, nz) ->
    begin match eval_def env def e with
    | Nat 0 -> eval_def env def z
    | Nat _ -> eval_def env def nz
    | _ -> raise (Stuck IfZeroNonNat)
    end
  | MApp _ -> e
  | App (f, e') ->
  printf "app2\n";
  (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm f));
  printf "\n";
  (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e'));
printf "\n\n";
printf "%s\n\nHEREE\n\n" (string_of_tm e);
    begin match f with
    | Fun (x, _, body) -> eval_def env def @@ subst x e' body
    | _ -> printf "askldfjasldf\n"; eval_def env def @@ App (eval_def env def f, eval_def env def e')
   (* | Ref _ -> eval env @@ App (eval env f
    | MVar _ -> e
    | App (e1, e2) -> App (eval env e1, eval env e2)
    (*| App _ as sub -> eval env (App ((eval env sub), e'))*)
    | _ -> raise (Stuck ApplyNonFun)*)
    end
  | Fun _ as v -> printf "fun\n" ; Core.Sexp.output_hum Stdio.stdout (sexp_of_tm v); printf "\n\n"; v
  | BVar _ -> raise (Stuck BadBoundVar) (* this should have been substituted by now! *)
  | UVar _ -> raise NotImplemented (* not intotally sure what into do here *)
  | MVar _ as v -> v

  
let get_defs e : tm list =
  filter_expr (fun x -> match x with Ref _ -> true | _ -> false) e
  |> List.map (fun ref -> match ref with Ref r -> r | _ -> "")
  |> VarSet.of_list
  |> VarSet.to_list
  |> List.map (fun r -> Ref r)

let rec eval2 (env : env) (e : tm) : tm =
(*printf "eval2\n";
(Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e));
  printf "\n\n";*)
  match e with
  | Nil -> Nil
  | Cons (x, xs) -> Cons (eval2 env x, eval2 env xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match l with
    | Nil -> n
    | Cons (y, ys) -> eval2 env @@ subst x y (subst xs ys c)  
    | _ -> e
    end
  | Nat n -> Nat n
  | Plus (e, e') -> 
    begin match eval2 env e, eval2 env e' with
    | Nat x, Nat y -> Nat (x + y)
    | _ -> raise (Stuck ArithNonNats)
    end
  | Minus (e, e') -> 
    begin match eval2 env e, eval2 env e' with
    | Nat x, Nat y -> Nat (max (x - y) 0)
    | _ -> raise (Stuck ArithNonNats)
    end
  | Times (e, e') -> 
    begin match eval2 env e, eval2 env e' with
    | Nat x, Nat y -> Nat (x * y)
    | _ -> raise (Stuck ArithNonNats)
    end
  | If0 (e, z, nz) ->
    begin match eval2 env e with
    | Nat 0 -> eval2 env z
    | Nat _ -> eval2 env nz
    | _ -> raise (Stuck IfZeroNonNat)
    end
  | MApp _ -> e
  | App (f, e') ->
    let left = eval2 env f in
    let right = eval2 env e' in
    begin match left, right with
    | Fun (x, _, e), _ -> eval2 env @@ subst x right e
    (*| App (_, _) -> let res = eval2 env f in
      begin match res with
      | App _ -> e
      | _ -> eval2 env @@ App (res, e')
      end *)
    | App (_, _), App (_, _) -> eval2 env @@ App (eval2 env left, eval2 env right)
    | _, App (_,_) -> eval2 env @@ App (left, right)
    | App (_,_), _ -> eval2 env @@ App (left, right)
    | _ -> MApp (left, right)
    (*| Fun (x, _, e), Nil -> eval2 env @@ subst x e' e
    | Fun (x, _, e), Cons (_, _) -> eval2 env @@ subst x e' e
    | Fun (x, _, e), MVar _ -> eval2 env @@ subst x e' e*)
    (*| App (_, _), App (_, _) -> App ((eval2 env f), (eval2 env e'))
    | App (_, _), _ -> App ((eval2 env f), e')
    | _, App (_, _) -> App (f, (eval2 env e'))
    | _ -> e *)
   (* | Ref _ -> eval env @@ App (eval env f
    | MVar _ -> e
    | App (e1, e2) -> App (eval env e1, eval env e2)
    | App _ as sub -> eval env (App ((eval env sub), e'))
    | _ -> raise (Stuck ApplyNonFun)*)
    end
  | Fun _ as v -> v
  | BVar _ -> raise (Stuck BadBoundVar) (* this should have been substituted by now! *)
  | Ref r -> Ref r
  | MRef r -> MRef r
  | UVar _ -> raise NotImplemented (* not intotally sure what into do here *)
  | MVar x -> MVar x (* uninterpreted metavariables left as-is *)
    

let apply_def env def e =
  printf "applying def %s\n\n" (string_of_tm def);
  match def with
  | Ref r ->
    let (args, t) = List.assoc r env in
    let into = fold_right (fun (x, ty) acc -> Fun (x, ty, acc)) args t in
    subst_first_expr def into e
  | _ -> raise NotImplemented



exception DefMatchFail
exception CommonsenseFail
exception IHMatchFail
exception TheoremMatchFail
exception NoChange


(* unroll definition closure *)
let unroll_def env def =
  match def with
  | Ref r ->
    let (args, t) = List.assoc r env in
    fold_right (fun (x, ty) acc -> Fun (x, ty, acc)) args t
  | _ -> raise DefMatchFail

(* assumption that defn is only evoked on one instance
backtrack attempts *)
let try_def_match env def prev curr =
  let fn = match def with | Ref r -> r | _ -> raise DefMatchFail in
  let into = unroll_def env def in
  
  let attempt expr =
    eval2 env @@ subst_first_expr def into expr
  in
  (* mark ref to avoid repassing *)
  let get_next expr = 
    subst_first_expr (Ref fn) (MRef fn) expr
  in
  
  let rec go e next : bool =
    let res = attempt e in
    printf "Candidate\n";
    Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e);
      printf "\n\n";
    printf "Next\n";
    Core.Sexp.output_hum Stdio.stdout (sexp_of_tm next);
    printf "\n\nsubst from\n";
   (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm def));
   printf "\n\n";
    printf "into\n";
   (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm into));
  printf "\n\n";
  printf "within\n";
  (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm e));
  printf "\n\n";
    printf "Attempt %s\n" fn;
    Core.Sexp.output_hum Stdio.stdout (sexp_of_tm res);
    printf "\n\n";
    printf "Attempt of next %s\n" fn;
    Core.Sexp.output_hum Stdio.stdout (sexp_of_tm @@ attempt next);
    printf "\n\n";
    (* equality not up to MRef! *)
    printf "Next = next next\n";
    Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_bool (next = get_next next));
    printf "\n\n";
    printf "Next = e\n";
    Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_bool (next = e));
    printf "\n\n";
    printf "Curr = attempt\n";
    Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_bool (curr $= e));
    printf "\n\n";
    if (curr $= res) then true else 
    if (e = next) then false else (* tried all possible transforms *)
    go next (get_next next)
  in
  go prev (get_next prev)


let check_def env defs prev curr =
  let ls = List.map (fun def -> try_def_match env def prev curr) defs in
  printf "\nLISTSILT\n";
  (*Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_list sexp_of_tm ls);
  let ls = List.map (fun t -> curr = restore t) ls in
  printf "\n\n";*)
  Core.Sexp.output_hum Stdio.stdout (Core.sexp_of_list Core.sexp_of_bool ls);
  printf "\n\n";
  Core.Sexp.output_hum Stdio.stdout (sexp_of_tm curr);
  printf "\n\n";
  List.mem true ls
  
  
let eval_step (env: env) (thms : thms) (ihs : ihs) (prev : tm) (curr : tm) (j : justification) = 
  if prev = curr then raise NoChange else
  match j with
  | ByDefinition None -> 
    printf "= %s  -- by defn\n" (string_of_tm curr);
    (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm curr));
    printf "\n\n";
    printf "HERE\n";
    if not (check_def env (get_defs prev) prev curr) then raise DefMatchFail;
    printf "DONE\n\n";
    (*let check env e1 e2 =
      e2 = eval env e1
    in
    if not (at_mismatch check env prev curr) 
    then raise DefMatchFail;*)
  | ByDefinition (Some def) ->
    printf "= %s  -- by defn of %s\n" (string_of_tm curr) def;
    (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm curr));
    printf "\n\n";
    printf "HERE\n";
    if not (check_def env [Ref def] prev curr) then raise DefMatchFail;
    printf "DONE\n\n";
  | ByCommonsense -> 
    printf "= %s  -- by commonsense " (string_of_tm curr);
    (* assoc or commut can happen at higher level *)
    if not (check_commonsense env prev curr) ||
    not (at_mismatch check_commonsense env prev curr) 
    then 
    printf "\n";
    raise CommonsenseFail;
  | ByIH ih -> 
    printf "= %s  -- by %s: " (string_of_tm curr) ih;
    let ih = assoc ih ihs in
    let res = subst_first_expr ih.lhs ih.rhs prev in
    printf "/ %s -> %s /\n" (string_of_tm ih.lhs) (string_of_tm ih.rhs);
    (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm res));
    printf "\n";
    (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm curr));
    printf "\n\n";
    if not (res $= curr)
    then raise IHMatchFail;
  | ByTheorem t -> 
    printf "= %s  -- by theorem %s\n" (string_of_tm curr) t;
    let stmt = assoc t thms in
    let f = (fun c (x, _) -> subst x (UVar x) c) in
    let claim_lhs = fold_left f stmt.claim.eqn.lhs stmt.quantifiers in
    let claim_rhs = fold_left f stmt.claim.eqn.rhs stmt.quantifiers in
    (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm claim_lhs));
    printf "\n\n";
    (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm claim_rhs));
    printf "\n\n";
    let res = subst_first_expr claim_lhs claim_rhs prev in
    if not (res $= curr)
    then raise TheoremMatchFail;
    ()

  

let eval_side side env thms ihs =
  printf "Side: %s\n" (string_of_tm side.start);
  (Core.Sexp.output_hum Stdio.stdout (sexp_of_tm side.start));
printf "\n\n";
  let start = side.start in
  let res = 
    fold_left (fun prev step -> let _ = (eval_step env thms ihs prev (fst step) (snd step)) in (fst step)) start side.steps
  in
  res


let check_case case env thms =
  (* TODO check induction variable is same *)
  printf "Case: %s\n" (string_of_pattern case.pattern);
  let _ = case.var in
  let _ = case.pattern in
  (* ihs : (name * eqn) list; TOD0 *)
  let wts = case.wts in  (* assumed into be correct into claim *)
  if not (wts.lhs = case.lhs.start) then raise NotImplemented else
  let lhs = eval_side case.lhs env thms case.ihs  in
  let rhs = eval_side case.rhs env thms case.ihs in
  let _ = lhs = rhs && (wts.rhs = rhs) in
  ()
  
let check_proof (_(*var*), cases) _(*claim*) env thms = 
  let _ = fold_left (fun _ x -> check_case x env thms) () cases in
  ()

let infer_wts (name : name) (case : case) (thm_stmt : thm_stmt) : eqn =
  match case.pattern with
  | Pat_nil -> subst_eqn name Nil thm_stmt.claim.eqn
  | Pat_cons (x, xs) -> subst_eqn name (Cons (MVar x, MVar xs)) thm_stmt.claim.eqn

let exec_stmt (env : env) (thms: thms) (s : stmt) : env * thms =
  match s with
  | Print tm -> print_endline @@ string_of_tm @@ eval env tm; (env, thms)
  | Definition d -> 
    let env = (d.name, (d.args, d.body)) :: env in (* TODO: make this CBV *)
    printf "Defined %s\n" d.name;
    (env, thms)
  | Thm {name; stmt; proof} -> 
    printf "\nTheorem: %s\n" name;
    match proof with
    | Axiom -> 
      printf "By axiom\n";
      (env, (name, stmt) :: thms)
    | Proof (n, c::cs) -> 
      let cases = (n, c::cs)
      in (*TODO check generated wts against provided *)
      (* TODO inject WTS, checked against claim so cases prove claim *)
      let _ = map (fun c -> infer_wts (fst cases) c stmt) (snd cases) in
      let _args = stmt.quantifiers in
      let claim = stmt.claim.eqn in
      let thms = (name, stmt) :: thms in (* TODO thm -> claim? *)
      let () = check_proof cases claim env thms in
      printf "\n%s □\n" name;
      (env, thms)
    | _ -> raise NotImplemented


let check_prog (p : program) : env * thms =
  printf "Checking program...\n";
  fold_left (fun (env, thms) stmt  -> exec_stmt env thms stmt ) ([], []) p

