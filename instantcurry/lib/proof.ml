open Synint
open Printing
open Printf
open List
open Term


exception BadBoundVar
exception DefMatchFail
exception CommonsenseFail
exception IHMatchFail
exception TheoremMatchFail
exception EvalMatchFail
exception WTSMatchFail
exception SideMatchFail
exception PointlessStep
 

(* unmark MApp to App and MRef to Ref *)
let unmark e =
  let rec go e =
    match e with
    | Nil -> Nil
    | Cons (x, xs) -> Cons (go x, go xs)
    | ListCase (l, n, x, xs, c) -> 
      ListCase (go l, go n, x, xs, go c)
    | Nat n -> Nat n
    | Plus (e, e') -> Plus (go e, go e')
    | Minus (e, e') -> Minus (go e, go e')
    | Times (e, e') -> Times (go e, go e')
    | If0 (e, z, nz) -> If0 (go e, go z, go nz)
    | App (f, e') | MApp (f, e') -> App (go f, go e')
    | Fun (f, ty, e) | MFun (f, ty, e)  -> 
      Fun (f, ty, go e)
    | BVar v -> BVar v
    | Ref v | MRef v -> Ref v
    | UVar v -> UVar v
    | MVar v -> MVar v
  in
  go e

(* check equality in parallel until mismatch, then apply check *)
let rec at_mismatch (check : env -> tm -> tm -> bool) env e1 e2 : bool =
  let eq = at_mismatch check env in
  let ( @= ) = eq in

  match e1, e2 with
  | Nil, Nil -> true
  | Cons (x, xs), Cons (y, ys) -> 
    if not (x @= y) then check env x y && xs = ys
    else xs @= ys
  | ListCase (l, n, _, _, c), ListCase (l', n', _, _, c') -> 
    if not (l = l') then check env l l' && n = n' && c = c'
    else if not (n @= n') then check env n n' && c = c'
    else c @= c'
  | Nat n, Nat m -> n = m
  | Plus (a1, a2), Plus (b1, b2)
  | Minus (a1, a2), Minus (b1, b2)
  | Times (a1, a2), Times (b1, b2) 
  | App (a1, a2), App (b1, b2) -> 
    if not (a1 @= b1) then check env a1 b1 && a2 = b2
    else a2 @= b2
  | MApp (a1, a2), MApp (b1, b2) -> 
    if not (a1 @= b1) then check env a1 b1 && a2 = b2
    else a2 @= b2
  | If0 (e, z, nz), If0 (e', z', nz') ->
    if not (e @= e') then check env e e' && z = z' && nz = nz'
    else if not (z = z') then check env z z' && nz = nz'
    else nz @= nz'
  | Fun (f, _ty, e), Fun (g, _ty', e') -> 
    String.equal f g &&
    (if not (e @= e') then check env e e'
    else true)
  | MFun (f, _ty, e), MFun (g, _ty', e') -> 
    String.equal f g &&
    (if not (e @= e') then check env e e'
    else true)
  | BVar x, BVar y -> String.equal x y
  | Ref x, Ref y -> String.equal x y
  | MRef x, MRef y -> String.equal x y
  | UVar x, UVar y -> String.equal x y
  | MVar x, MVar y -> String.equal x y
  | _ -> check env e1 e2

  
let get_defs e : tm list =
  filter_expr (fun x -> match x with Ref _ -> true | _ -> false) e
  |> List.map (fun ref -> match ref with Ref r -> r | _ -> "")
  |> VarSet.of_list
  |> VarSet.to_list
  |> List.map (fun r -> Ref r)


(* evaluate to normal form *)
let rec eval (env : env) (e : tm) : tm =
  match e with
  | Nil -> Nil
  | Cons (x, xs) -> Cons (eval env x, eval env xs)
  | ListCase (l, n, x, xs, c) -> 
    begin match eval env l with
    | Nil -> eval env n
    | Cons (y, ys) -> 
      eval env @@ 
      subst_expr (BVar x) y (subst_expr (BVar xs) ys c) 
    | _ -> e
    end
  | Nat n -> Nat n
  | Plus (e, e') -> 
    begin match eval env e, eval env e' with
    | Nat x, Nat y -> Nat (x + y)
    | _ -> Plus (eval env e, eval env e')
    end
  | Minus (e, e') -> 
    begin match eval env e, eval env e' with
    | Nat x, Nat y -> Nat (max (x - y) 0)
    | _ -> Minus (eval env e, eval env e')
    end
  | Times (e, e') -> 
    begin match eval env e, eval env e' with
    | Nat x, Nat y -> Nat (x * y)
    | _ -> Times (eval env e, eval env e')
    end
  | If0 (e, z, nz) ->
    begin match eval env e with
    | Nat 0 -> eval env z
    | Nat _ -> eval env nz
    | _ -> If0 (eval env e, eval env z, eval env nz)
    end
  | MApp _ -> e
  | App (f, e') ->
    let left = eval env f in
    let right = eval env e' in
    begin match left, right with
    | Fun (x, _, body), _ -> 
      eval env @@ subst_expr (BVar x) right body
    | App (_, _), App (_, _) -> eval env @@ App (left, right)
    | _, App (_,_) -> eval env @@ App (left, right)
    | App (_,_), _ -> eval env @@ App (left, right)
    | MFun _, _ -> MApp (left, right) (* don't apply MFun *)
    | _ -> MApp (left, right) (* mark to prevent repassing *)
    end
  | Fun _ as v -> v
  | MFun _ as v -> v
  | BVar _ -> raise BadBoundVar (* this should have been substituted by now! *)
  | Ref r -> Ref r
  | MRef r -> MRef r
  | UVar _ -> e
  | MVar x -> MVar x (* uninterpreted metavariables left as-is *)
  
    
let check_commonsense env prev curr : bool =
  if (prev = curr) then true else
  (* by eval *)
  if (curr = unmark @@ eval env prev) then true else
  match prev, curr with
  | Plus (Nat 0, e), _
  | Plus (e, Nat 0), _ -> 
    printf "(add 0)\n";
    curr = e
  
  | Times (Nat 1, e), _
  | Times (e, Nat 1), _ ->
    printf "(times 1)\n"; 
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
 
  | _ -> false


(* unroll definition closure *)
let unroll_def env def =
  match def with
  | Ref r ->
    let (args, t) = List.assoc r env in
    fold_right (fun (x, ty) acc -> Fun (x, ty, acc)) args t
  | _ -> raise DefMatchFail


(* assumption that defn is only evoked on one instance *)
let try_def_match env def prev curr =
  let fn = 
    match def with 
    | Ref r -> r
    | _ -> raise DefMatchFail 
  in
  let into = unroll_def env def in
  
  let attempt expr =
    eval env @@ subst_first_expr def into expr
  in
  (* mark ref to avoid resubstituing the same node *)
  let get_next expr = 
    subst_first_expr (Ref fn) (MRef fn) expr
  in
  
  let rec go e next : bool =
    let res = attempt e in
    if (curr $= res) then true else
    if (e = next) then false else (* tried all possible substitutions *)
    go next (get_next next)
  in
  go prev (get_next prev)


let check_def env defs prev curr =
  let ls = List.map (fun def -> try_def_match env def prev curr) defs in
  List.mem true ls
  
  
let eval_step (env: env) (thms : thms) (ih : eqn) (prev : tm) (curr : tm) (j : justification) = 
  if prev = curr then raise PointlessStep else
  match j with
  | ByEval ->
    printf "= %s  -- by eval\n" (string_of_tm curr);
    if not (curr $= eval env (unmark prev)) then
    raise EvalMatchFail
  | ByDefinition None -> 
    printf "= %s  -- by defn\n" (string_of_tm curr);
    if not (check_def env (get_defs prev) prev curr) then raise DefMatchFail;
  | ByDefinition (Some def) ->
    printf "= %s  -- by defn of %s\n" (string_of_tm curr) def;
    if not (check_def env [Ref def] prev curr) then raise DefMatchFail;
  | ByCommonsense -> 
    printf "= %s  -- by commonsense " (string_of_tm curr);
    (* assoc or commut can happen at higher level *)
    if not (check_commonsense env prev curr) then
    if not (at_mismatch check_commonsense env prev curr) 
    then raise CommonsenseFail;
  | ByIH -> 
  
    printf "= %s  -- by IH: " (string_of_tm curr);
    printf "/ %s = %s /\n" (string_of_tm ih.lhs) (string_of_tm ih.rhs);
    
    let res = eval env @@ subst_first_expr ih.lhs ih.rhs prev in
    if not (res $= curr) then
      (
      (* try IH equation in other direction too *)
      let res = eval env @@ subst_first_expr ih.rhs ih.lhs prev in
      if not (res $= curr) then raise IHMatchFail;)
  | ByTheorem t -> 
    printf "= %s  -- by theorem %s\n" (string_of_tm curr) t;
    let stmt = assoc t thms in
    let f = (fun c (x, _) -> subst_expr (MVar x) (UVar x) c) in
    let claim_lhs = fold_left f stmt.claim.eqn.lhs stmt.quantifiers in
    let claim_rhs = fold_left f stmt.claim.eqn.rhs stmt.quantifiers in
    let res = eval env @@ subst_first_expr claim_lhs claim_rhs prev in
    if not (res $= curr)
    then raise TheoremMatchFail;
    ()

  

let eval_side side env thms ih =
  printf "Side: %s\n" (string_of_tm side.start);
  let start = side.start in
  let res = 
    fold_left (fun prev step -> let _ = (eval_step env thms ih prev (fst step) (snd step)) in (fst step)) start side.steps
  in
  res


let check_case case env thms =
  printf "Case: %s\n" (string_of_pattern case.pattern);
  let _ = case.var in
  let _ = case.pattern in

  let wts = case.wts in 
  if not (wts.lhs $= case.lhs.start) then raise WTSMatchFail else
  if not (wts.rhs $= case.rhs.start) then raise WTSMatchFail else
  let lhs' = eval_side case.lhs env thms case.ih in
  let rhs' = eval_side case.rhs env thms case.ih in
  if not (lhs' = rhs') then raise SideMatchFail else
  ()
  
let check_proof (_(*var*), cases) _(*claim*) env thms = 
  let _ = fold_left (fun _ x -> check_case x env thms) () cases in
  ()



let infer_wts (name : name) (pat : pattern) (wts_opt : eqn option) (thm_stmt : thm_stmt) : eqn =
  let inferred =
    let f e =
      match pat with
      | Pat_nil -> subst_expr (MVar name) Nil e
      | Pat_cons (x, xs) -> 
        subst_expr (MVar name) (Cons (MVar x, MVar xs)) e
    in
      { 
        lhs = thm_stmt.claim.eqn.lhs |> f;
        rhs = thm_stmt.claim.eqn.rhs |> f;
      }
  in
  match wts_opt with
  | None -> inferred
  | Some wts -> 
    if not (wts.lhs $= inferred.lhs) || 
     not (wts.rhs $= inferred.rhs)
     then raise WTSMatchFail else wts
     
     
(* list -> xs *)
let infer_ih (name : name) (pat : pattern) (ih_opt : eqn option) (thm_stmt : thm_stmt) : eqn =
  let inferred =
    let f e =
      match pat with
      | Pat_nil -> e
      | Pat_cons (_, xs) -> 
        subst_expr (MVar name) (MVar xs) e
    in
      { 
        lhs = thm_stmt.claim.eqn.lhs |> f;
        rhs = thm_stmt.claim.eqn.rhs |> f;
      }
  in
  match ih_opt with
  | None -> inferred
  | Some ih -> 
    if not (ih.lhs $= inferred.lhs) || not (ih.rhs $= inferred.rhs)
     then raise IHMatchFail else ih


let rename_in_scope stmt =
  match stmt with
  | Definition d ->
    let args' = Core.List.map ~f:(fun (x, ty) -> ((fresh x), ty)) d.args in
    let body' = 
      Core.List.fold2_exn ~f:(fun acc (a, _) (a', _) -> 
        subst_expr (BVar a) (BVar a') acc)
      ~init:d.body d.args args'
    in
    Definition {
      name = d.name;
      isrec = d.isrec;
      args = args';
      rty = d.rty;
      fnsig = d.fnsig;
      body = body';
    }
    | _ -> stmt

let exec_stmt (env : env) (thms: thms) (s : stmt) : env * thms =
  match s with
  (*| Const (x, v) -> ()*)
  | Print tm -> printf "%s\n" (string_of_tm @@ eval env tm); (env, thms)
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
      in 
      
      let _args = stmt.quantifiers in
      let claim = stmt.claim.eqn in
      let () = check_proof cases claim env thms in
      let thms = (name, stmt) :: thms in (* TODO thm -> claim? *)
      printf "\n%s □\n" name;
      (env, thms)
    | _ -> raise NotImplemented


let check_prog (p : program) : env * thms =
  fold_left (fun (env, thms) stmt  -> exec_stmt env thms stmt ) ([], []) p

