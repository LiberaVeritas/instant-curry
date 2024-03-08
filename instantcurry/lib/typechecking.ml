open Synint

(* typechecking *)

exception IllTyped of string (* todo: MORE SPECIFIC TYPE ERRORS *)
type ctx = (name * ty) list
type thm_ctx = (name * thm_stmt) list

(* Delta: metavars, Sigma: Refs, Gamma: bvars *)
let rec typecheck_tm (delta : ctx) (sigma : ctx) (gamma : ctx) (e : tm) : ty =
  (* print_endline @@ Printing.string_of_tm e ; *)
  match e with
  | Nil ty -> Ty_List ty
  | Cons (x, xs) -> 
    let ty = typecheck_tm delta sigma gamma x in
    if typecheck_tm delta sigma gamma xs = Ty_List ty
      then Ty_List ty else raise (IllTyped "cons")
  | ListCase (l, n, x, xs, c) -> 
    begin match typecheck_tm delta sigma gamma l with
    | Ty_List t as lt -> 
      let nt = typecheck_tm delta sigma gamma n in
      if typecheck_tm delta sigma ((x, t) :: (xs, lt) :: gamma) c = nt
        then nt
        else raise (IllTyped "match cases disagree")
    | _ -> raise (IllTyped "match nonlist")
    end
  | Nat _ -> Ty_Nat
  | Plus (e, e') | Minus (e, e') | Times (e, e') -> 
    if typecheck_tm delta sigma gamma e = Ty_Nat && typecheck_tm delta sigma gamma e' = Ty_Nat
      then Ty_Nat else raise (IllTyped "arith non-nats")
  | If0 (e, z, nz) ->
    let ty = typecheck_tm delta sigma gamma z in
    if typecheck_tm delta sigma gamma e = Ty_Nat && ty = typecheck_tm delta sigma gamma nz
      then ty else raise (IllTyped "if0")
  | App (e, e') ->
    begin match typecheck_tm delta sigma gamma e with
    | Ty_Arrow (t, t') -> 
      if typecheck_tm delta sigma gamma e' = t 
        then t' else raise (IllTyped "apply other")
    | _ -> raise (IllTyped "apply non-fn")
    end
  | Fun (x, ty, e) ->
    let rty = typecheck_tm delta sigma ((x, ty) :: gamma) e in
    Ty_Arrow (ty, rty)
  | BVar x -> begin try List.assoc x gamma with
    | Not_found -> raise (IllTyped "no bvar") end
  | MVar x -> begin try List.assoc x delta with
    | Not_found -> raise (IllTyped "no mvar") end
  | Ref x -> begin try List.assoc x sigma with
    | Not_found -> raise (IllTyped "no ref") end
  | UVar _ -> raise NotImplemented

let typecheck_eqn (delta : ctx) (sigma : ctx) (e : eqn) : unit =
  let tc = typecheck_tm delta sigma [] in
  if tc e.lhs <> tc e.rhs then raise (IllTyped "eqn types disagree")

let typecheck_step (delta : ctx) (sigma : ctx) 
                   (prev : tm) (next : tm) (_ : justification) : unit =
  let tc = typecheck_tm delta sigma [] in
  if tc prev <> tc next then raise (IllTyped "step types disagree")

let typecheck_steps (delta : ctx) (sigma : ctx) (s : side) : unit =
  let _ = List.fold_left 
  (fun prev (next, j) -> typecheck_step delta sigma prev next j; next) s.start s.steps
  in ()

let typecheck_case (delta : ctx) (sigma : ctx) (c : case) : unit =
  let delta = match c.pattern with (* todo: what if they induct on l but case is k = [] *)
  | Pat_cons (x, xs) -> begin match List.assoc_opt c.var delta with
    | Some (Ty_List ty as tyl) -> (x, ty) :: (xs, tyl) :: delta
    | Some _ -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end
  | Pat_nil -> begin match List.assoc_opt c.var delta with
    | Some (Ty_List _) -> delta
    | Some _ -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end
  in 
  (* todo: check wts is valid *)
  (* todo: check ihs are valid *)
  if c.wts.lhs <> c.lhs.start then raise (IllTyped "invalid lhs start");
  typecheck_steps delta sigma c.lhs;
  if c.wts.rhs <> c.rhs.start then raise (IllTyped "invalid rhs start");
  typecheck_steps delta sigma c.rhs

let typecheck_proof (delta : ctx) (sigma : ctx) (p : proof) : unit =
  let _ = match p with (* todo: surely there is a nicer way to do this? *)
  | Proof (_, cases) -> List.map (typecheck_case delta sigma) cases
  | Axiom -> []
  in ()

let typecheck_stmt (delta : ctx) (sigma : ctx) (s : stmt) : ctx =
  match s with
  | Definition d -> 
    let gamma = List.fold_left (fun xs x -> x :: xs) [] d.args in
    let sigma = (d.name, d.fnsig) :: sigma in
    let ty = typecheck_tm delta sigma gamma d.body in
    if ty = d.rty then sigma else raise (IllTyped "letrec disagree")
  | Print t -> 
    let _ = typecheck_tm delta sigma [] t in 
    sigma
  | Thm t ->  (* todo: add to context of theorems *)
    let delta = t.stmt.quantifiers @ delta in
    typecheck_eqn delta sigma t.stmt.claim;
    typecheck_proof delta sigma t.proof;
    sigma


let typecheck_prog (p : program) =
  List.fold_left (fun sigma stmt -> typecheck_stmt [] sigma stmt) [] p

(* TODO LIST
   
1. case analysis, get that [] and x :: xs are constructors of l
2. substitution of induction variables
3. generate IH
4. apply IH with congruence
    a. congruence over function application? is it needed?

*)

