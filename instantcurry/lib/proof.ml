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
    | Cons (e1, e2) -> 
      fold f e1 acc |> fold f e2
    | ListCase (_l, n, _x, _y, c) -> fold f n acc |> fold f c
    | If0 (_z, n, y) -> fold f n acc |> fold f y
    | Fun (_f, _typ, e') -> fold f e' acc
    | Nil | Nat _
    | BVar _ | Ref _ 
    | UVar _ | MVar _ 
      -> f e acc
  in
  fold f expr init

let filter_expr (f : tm -> bool) (expr : tm) =
  let f' tm acc =
    if f tm then tm::acc else acc
  in
  fold_expr f' [] expr

  
let rec fvs (e : tm) : VarSet.t =
  match e with
  | Nil -> empty
  | Cons (x, xs) -> union (fvs x) (fvs xs)
  | ListCase (l, n, x, xs, c) ->  (* TODO: remove x and xs only from c *)
    let varlist = map fvs [l; n; c] in
    let free = fold_left union empty varlist in
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
  | UVar y -> if x = y then s else UVar y (*raise NotImplemented*)

and rename (x : name) (e : tm) : (name * tm) = 
  let x' = fresh x in
  (x', subst x (BVar x') e)

type clos = ((string * ty) list * tm)
type env = (string * clos) list
type thms = (string * thm_stmt) list
type constrs = (string * tm) list
type ihs = (string * eqn) list

(* to normal form given env *)
let rec eval (env : env) (e : tm) : tm =
  match e with
  | Nil -> Nil
  | Cons (x, xs) -> Cons (eval env x, eval env xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match l with
    | Nil -> eval env n
    | MVar _ -> e
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
    begin match f with
    | Fun (x, _, e) -> eval env @@ subst x e' e
    | Ref _ -> eval env @@ eval env f
    | MVar _ -> e
    | App (e1, e2) -> App (eval env e1, eval env e2)
    (*| App _ as sub -> eval env (App ((eval env sub), e'))*)
    | _ -> raise (Stuck ApplyNonFun)
    end
  | Fun _ as v -> v
  | BVar _ -> raise (Stuck BadBoundVar) (* this should have been substituted by now! *)
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

(* check parallel equality until mismatch, then apply check *)
let rec at_mismatch (check : env -> tm -> tm -> bool) env e1 e2 : bool =
  match e1, e2 with
  | Nil, Nil -> true
  | Cons (x, xs), Cons (y, ys) -> 
    if not (x = y) then check env x y && xs = ys
    else at_mismatch check env xs ys
  | ListCase (_l, n, _x, _xs, c), ListCase (_l', n', _y, _ys, c') -> 
    if not (n = n') then check env n n' && c = c'
    else at_mismatch check env c c'
  | Nat n, Nat m -> n = m
  | Plus (a1, a2), Plus (b1, b2)
  | Minus (a1, a2), Minus (b1, b2)
  | Times (a1, a2), Times (b1, b2) 
  | App (a1, a2), App (b1, b2) -> 
    if not (a1 = b1) then check env a1 b1 && a2 = b2
    else at_mismatch check env a2 b2
  | If0 (e, z, nz), If0 (e', z', nz') ->
    if not (e = e') then check env e e' && z = z' && nz = nz'
    else if not (z = z') then check env z z' && nz = nz'
    else at_mismatch check env nz nz'
  | Fun (f, _ty, e), Fun (g, _ty', e') -> 
    String.equal f g &&
    (if not (e = e') then check env e e'
    else true)
  | BVar x, BVar y -> String.equal x y
  | Ref x, Ref y -> String.equal x y
  | UVar x, UVar y -> String.equal x y
  | MVar x, MVar y -> String.equal x y
  | _ -> false


let check_commonsense env prev curr : bool =
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
    a1 = b1 && a2 = b2 && a3 = b3
  (* commutativity *)
  | Plus (a1, a2), Plus (b1, b2)
  | Times (a1, a2), Times (b1, b2) -> 
    printf "(commut)\n";
    a1 = b2 && a2 = b1
  | _ -> (curr = eval env prev)
  


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
    | ListCase (l, n, _x, _xs, c) -> 
      ListCase (l, sub n, _x, _xs, sub c)
    | Nat n -> if from = (Nat n) then into else (Nat n)
    | Plus (e, e') -> Plus (sub e, sub e')
    | Minus (e, e') -> Minus (sub e, sub e')
    | Times (e, e') -> Times (sub e, sub e')
    | If0 (e, z, nz) -> If0 (sub e, sub z, sub nz)
    | App (f, e') -> App (sub f, sub e')
    | Fun (f, ty, e) -> 
      if from = (Fun (f, ty, e)) then into else (Fun (f, ty, e))
    | BVar v -> if from = (BVar v) then into else (BVar v)
    | Ref v -> if from = (Ref v) then into else (Ref v)
    | UVar v -> if from = (UVar v) then into else (UVar v)
    | MVar v -> if from = (MVar v) then into else (MVar v)
  in
  sub within

(*
list of refs 
*)
let eval_step (env: env) (thms : thms) (ihs : ihs) (prev : tm) (curr : tm) (j : justification) : bool = 
  match j with
  | ByDefinition -> 
    printf "= %s  -- by defn\n" (string_of_tm curr);
    let check env e1 e2 =
      e2 = eval env e1
    in
    at_mismatch check env prev curr
  | ByCommonsense -> 
    printf "= %s  -- by commonsense " (string_of_tm curr);
    (* assoc or commut can happen at higher level *)
    if not (check_commonsense env prev curr) then
    at_mismatch check_commonsense env prev curr
    else (printf "\n"; raise NotImplemented)
    
  | ByIH ih -> 
    printf "= %s  -- by %s: " (string_of_tm curr) ih;
    let ih = assoc ih ihs in
    let res = subst_expr ih.lhs ih.rhs prev in
    printf "/ %s -> %s /\n" (string_of_tm ih.lhs) (string_of_tm ih.rhs);
    res = curr
  | ByTheorem t -> 
    printf "= %s  -- by theorem %s\n" (string_of_tm curr) t;
    let stmt = assoc t thms in
    let f = (fun c (x, _) -> subst x (UVar x) c) in
    let claim_lhs = fold_left f stmt.claim.eqn.lhs stmt.quantifiers in
    let claim_rhs = fold_left f stmt.claim.eqn.rhs stmt.quantifiers in
    (* TODO *)
    claim_lhs = claim_rhs

  

let eval_side side env thms ihs =
  printf "Side: %s\n" (string_of_tm side.start);
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

