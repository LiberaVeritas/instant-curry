open Synint
open List


module VarSet = Set.Make(String)
let mem = VarSet.mem
let empty = VarSet.empty
let union = VarSet.union
let remove = VarSet.remove


let list_of_sexp = Core.list_of_sexp
let string_of_sexp = Core.string_of_sexp
let sexp_of_list = Core.sexp_of_list
let sexp_of_string = Core.sexp_of_string


type clos = ((string * ty) list * tm) [@@deriving sexp]
type env = (string * clos) list [@@deriving sexp]
type thms = (string * thm_stmt) list [@@deriving sexp]
type constrs = (string * tm) list [@@deriving sexp]
type ihs = (string * eqn) list [@@deriving sexp]


(* get all free variables *)
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
  | App (e, e') | MApp (e, e') -> union (fvs e) (fvs e')
  | Fun (x, _, e) | MFun (x, _, e) -> remove x (fvs e)
  | BVar x | Ref x | MRef x | MVar x -> VarSet.singleton x
  | UVar _ -> raise NotImplemented


let fold_expr (f : tm -> 'a -> 'a) (init : 'a) (expr : tm) =
  let rec fold f e acc =
    match e with
    | App (e1, e2) | Times (e1, e2)
    | Minus (e1, e2) | Plus (e1, e2)
    | Cons (e1, e2) | MApp (e1, e2) -> 
      fold f e1 acc |> fold f e2
    | ListCase (l, n, _, _, c) -> fold f l acc |> fold f n |> fold f c
    | If0 (s, n, y) -> fold f s acc |> fold f n |> fold f y
    | Fun (_, _, e') | MFun (_, _, e') -> fold f e' acc
    | Nil | Nat _
    | BVar _ | Ref _ | MRef _
    | UVar _ | MVar _ -> f e acc
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
  x ^ "~" ^ (string_of_int !ctr)


let same_name a b =
  match a, b with
  | BVar x, BVar y 
  | BVar x, MVar y
  | MVar x, BVar y
  | MVar x, MVar y ->
    String.equal x y
  | _ -> false

  
let has_name e name =
    match e with
  | BVar x
  | MVar x ->
    String.equal x name
  | _ -> false


(*
find all instances of `from` in `within` and 
replace with `into`

resolve free variable collisions
*)
let rec subst_expr from into within =
  let rec sub e =
    match e with
    | Nil -> if from = Nil then into else Nil
    | Cons (x, xs) -> Cons (sub x, sub xs)
    | ListCase (l, n, x, xs, c) -> 
      let l' = sub l in
      let n' = sub n in
      if has_name from x || has_name from xs 
        then ListCase (l', n', x, xs, c)
      else let (x', c') =
        if mem x (fvs into) then rename (BVar x) c else (x, c)
      in let (xs', c') =
        if mem xs (fvs into) then rename (BVar xs) c' else (xs, c')
      in ListCase (l', n', x', xs', sub c')
    | Nat n -> if from = (Nat n) then into else (Nat n)
    | Plus (e, e') -> Plus (sub e, sub e')
    | Minus (e, e') -> Minus (sub e, sub e')
    | Times (e, e') -> Times (sub e, sub e')
    | If0 (e, z, nz) -> If0 (sub e, sub z, sub nz)
    | App (f, e') -> App (sub f, sub e')
    | MApp (f, e') -> MApp (sub f, sub e')
    | Fun (x, ty, e) -> 
      if has_name from x then MFun (x, ty, e)
      else let (x', e') =
        if mem x (fvs into) then rename (BVar x) e else (x, e)
      in Fun (x', ty, sub e')
    | MFun (x, ty, e) -> 
      if has_name from x then MFun (x, ty, e)
      else let (x', e') =
        if mem x (fvs into) then rename (BVar x) e else (x, e)
      in MFun (x', ty, sub e')    
    | BVar v -> if from = (BVar v) then into else (BVar v)
    | UVar v -> if from = (UVar v) then into else (UVar v)
    | Ref v -> if from = (Ref v) then into else (Ref v)
    | MRef v -> if from = (MRef v) then into else (MRef v)
    | MVar v -> if from = (MVar v) then into else (MVar v)
  in
  unrename @@ sub within

(* replace x with fresh var *)
and rename x e =
  let (x', from, into) =
    match x with
    | BVar v -> let v' = fresh v in (v', BVar v, BVar v')
    (*| UVar v -> let v' = fresh v in (v', UVar v, UVar v')*)
    | MVar v -> let v' = fresh v in (v', MVar v, MVar v')
    | _ -> raise NotImplemented
  in
  (x', subst_expr from into e)

(* restore original variable name *)
and unrename e =
  let func x = 
    try fst @@ Core.String.lsplit2_exn ~on:'~' x
    with _ -> x
  in
  match e with
  | Nil -> e
  | Cons (x, xs) -> Cons (unrename x, unrename xs)
  | ListCase (l, n, x, xs, c) -> 
    ListCase (unrename l, unrename n, func x, func xs, unrename c)
  | Nat n -> Nat n
  | Plus (e, e') -> Plus (unrename e, unrename e')
  | Minus (e, e') -> Minus (unrename e, unrename e')
  | Times (e, e') -> Times (unrename e, unrename e')
  | If0 (e, z, nz) -> If0 (unrename e, unrename z, unrename nz)
  | App (f, e') -> App (unrename f, unrename e')
  | MApp (f, e') -> MApp (unrename f, unrename e')
  | Fun (f, ty, e) -> Fun (func f, ty, unrename e)
  | MFun (f, ty, e) -> MFun (func f, ty, unrename e)
  | BVar v -> BVar (func v)
  | UVar v -> UVar (func v)
  | Ref v -> Ref (func v)
  | MRef v -> MRef (func v)
  | MVar v -> MVar (func v)


  (* equality of terms, up to generalized variables, marked nodes, renamed vars *)
  let rec tm_eq e1 e2 =
    let e1 = unrename e1 in
    let e2 = unrename e2 in
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
    | Fun (f, _ty, e), Fun (g, _ty', e') 
    | MFun (f, _ty, e), Fun (g, _ty', e') 
    | Fun (f, _ty, e), MFun (g, _ty', e') 
    | MFun (f, _ty, e), MFun (g, _ty', e') -> 
      String.equal f g &&
      e $= e'
    | BVar _, BVar _ | MVar _, MVar _ -> same_name e1 e2
    | Ref x, Ref y -> String.equal x y
    | MRef x, MRef y -> String.equal x y
    | Ref x, MRef y -> not (String.equal x y)  (* Not equal! for definition substitutions *)
    | MRef x, Ref y -> not (String.equal x y)
    | UVar _, _ -> true
    | _, UVar _ -> true
    | _ -> false
  
  let ( $= ) = tm_eq
 
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
      if not (res $= x) then Cons (res, xs) else
      Cons (x, sub xs)
    | ListCase (l, n, x, xs, c) -> 
      if from $= n then ListCase (l, into, x, xs, c) else
      if from $= c then ListCase (l, n, x, xs, into) else
      let res = sub n in
      if not (res $= n) then ListCase (l, res, x, xs, c) else
      ListCase (l, sub n, x, xs, sub c)
    | Nat n -> if from $= (Nat n) then into else (Nat n)
    | Plus (e, e') -> 
      if from $= e then Plus (into, e') else
      if from $= e' then Plus (e, into) else
      let res = sub e in
      if not (res $= e) then Plus (res, e') else
      Plus (e, sub e')
    | Minus (e, e') -> 
      if from $= e then Minus (into, e') else
      if from $= e' then Minus (e, into) else
      let res = sub e in
      if not (res $= e) then Minus (res, e') else
      Minus (sub e, sub e')
    | Times (e, e') -> 
      if from $= e then Times (into, e') else
      if from $= e' then Times (e, into) else
      let res = sub e in
      if not (res $= e) then Times (res, e') else
      Times (sub e, sub e')
    | If0 (e, z, nz) -> 
      if from $= e then If0 (into, z, nz) else
      if from $= z then If0 (e, into, nz) else
      if from $= nz then If0 (e, z, into) else
      let res = sub e in
      if not (res $= e) then If0 (res, z, nz) else
      let res = sub z in 
      if not (res $= z) then If0 (e, res, nz) else
      If0 (e, z, sub nz)
    | App (f, e') -> 
      if from $= f then App (into, e') else
      if from $= e' then App (f, into) else
      let res = sub f in
      if not (res $= f) then App (res, e') else
      App (f, sub e')
    | MApp (a, b) -> MApp (a, b)
    | Fun (f, ty, e) | MFun (f ,ty, e) -> 
      Fun (f, ty, sub e)
    | BVar v -> if from = (BVar v) then into else (BVar v)
    | MRef r -> 
      begin match from with
      | MRef r' -> 
      if String.equal r r' then into else (MRef r) (* not equality up to MRef! *)
      | _ -> MRef r
      end
    | Ref v -> 
      begin match from with
      | Ref v' -> 
      if String.equal v v' then into else (Ref v) (* not equality up to MRef! *)
      | _ -> Ref v
      end
    | UVar x -> UVar x
    | MVar v -> if from = (MVar v) then into else (MVar v)
  in
  unrename @@ sub within
  

