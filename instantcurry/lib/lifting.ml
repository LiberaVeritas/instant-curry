open Synint

(* lifting from parse trees to ASTs *)

exception ScopeError of name
type scope = Term | Stmt | Meta
type scope_ctx = (name * scope) list

let rec lift_ty (ctx : scope_ctx) (ty : Icparser.Parsed_ast.ty) : ty =
  match ty with
  | Icparser.Parsed_ast.Ty_Nat -> Ty_Nat
  | Icparser.Parsed_ast.Ty_List ty -> Ty_List (lift_ty ctx ty)
  | Icparser.Parsed_ast.Ty_Arrow (ty, ty') -> Ty_Arrow (lift_ty ctx ty, lift_ty ctx ty')

let rec lift_tm (ctx : scope_ctx) (t : Icparser.Parsed_ast.tm) : tm =
  match t with
  | Icparser.Parsed_ast.Nil -> Nil Ty_Nat
  | Icparser.Parsed_ast.Cons (t, t') -> Cons (lift_tm ctx t, lift_tm ctx t')
  | Icparser.Parsed_ast.ListCase (l, n, x, xs, c) -> 
    ListCase (lift_tm ctx l, lift_tm ctx n, x, xs, lift_tm ((x, Term) :: (xs, Term) :: ctx) c)
  | Icparser.Parsed_ast.Nat n -> Nat n
  | Icparser.Parsed_ast.Plus (t, t') -> Plus (lift_tm ctx t, lift_tm ctx t')
  | Icparser.Parsed_ast.Minus (t, t') -> Minus (lift_tm ctx t, lift_tm ctx t')
  | Icparser.Parsed_ast.Times (t, t') -> Times (lift_tm ctx t, lift_tm ctx t')
  | Icparser.Parsed_ast.If0 (t, z, s) -> If0 (lift_tm ctx t, lift_tm ctx z, lift_tm ctx s)
  | Icparser.Parsed_ast.App (t, t') -> App (lift_tm ctx t, lift_tm ctx t')
  | Icparser.Parsed_ast.Fun (x, ty, t) -> Fun (x, lift_ty ctx ty, lift_tm ((x, Term) :: ctx) t)
  | Icparser.Parsed_ast.Var x -> match List.assoc_opt x ctx with
    | Some Term -> BVar x
    | Some Stmt -> Ref x
    | Some Meta -> MVar x
    | None -> raise (ScopeError x)

let lift_eqn (ctx : scope_ctx) (eqn : Icparser.Parsed_ast.eqn) : eqn =
  let (lhs, rhs) = eqn in
  { lhs = lift_tm ctx lhs; rhs = lift_tm ctx rhs }

let lift_pat (pat : Icparser.Parsed_ast.pattern) : pattern =
  match pat with
  | Pat_nil -> Pat_nil
  | Pat_cons (x, xs) -> Pat_cons (x, xs)
  | Pat_empty -> Pat_empty
  | Pat_node (l, x, r) -> Pat_node (l, x, r)

let lift_just (thms : name list) (just : Icparser.Parsed_ast.name) : justification =
  if just = "defn" then ByDefinition else
  if List.mem just thms then ByTheorem just
  else raise (ScopeError just)

let lift_side (thms : name list) (ctx : scope_ctx) (side : Icparser.Parsed_ast.side) : side =
  let (start, steps) = side in
  let start = lift_tm ctx start in
  let f = fun (tm, just) -> (lift_tm ctx tm, lift_just thms just) in
  { start = start;
    steps = List.map f steps }

let lift_case (thms : name list) (ctx : scope_ctx) (case : Icparser.Parsed_ast.case) : case =
  let (name, pat, ihs, wts, lhs, rhs) = case in
  let ctx = match pat with
  | Pat_cons (x, xs) -> (x, Meta) :: (xs, Meta) :: ctx  (* patterns introduce metavars *)
  | Pat_nil -> ctx in
  let thms = List.fold_left (fun thms (n, _) -> n :: thms) thms ihs in  (* ihs introduce new thms *)
  { var = name;
    pattern = lift_pat pat;
    ihs = List.map (function (name, ih) -> (name, lift_eqn ctx ih)) ihs; 
    wts = lift_eqn ctx wts;
    lhs = lift_side thms ctx lhs;
    rhs = lift_side thms ctx rhs }

let lift_proof (thms : name list) (ctx : scope_ctx) (prf : Icparser.Parsed_ast.proof) : proof =
  match prf with 
  | Proof (var, cases) -> Proof (var, List.map (lift_case thms ctx) cases)
  | Axiom -> Axiom

let lift_stmt (thms : name list) (ctx : scope_ctx) (stmt : Icparser.Parsed_ast.stmt) : name list * scope_ctx * stmt =
  match stmt with
  | Theorem (name, args, claim, prf) -> 
    let ctx' = List.fold_left
                (fun ctx (x, _) -> (x, Meta) :: ctx)
                ctx
                args in
    let args = List.map (fun (x, ty) -> (x, lift_ty ctx' ty)) args in
    let claim = lift_eqn ctx' claim in
    (name :: thms, ctx, Thm
                      { name = name;
                        stmt = { quantifiers = args; claim = claim};
                        proof = lift_proof thms ctx' prf })
  | Definition (f, isrec, args, ty, t) ->
    let ctx' = List.fold_left 
              (fun ctx arg -> (fst arg, Term) :: ctx) 
              ((f, Stmt) :: ctx) 
              args in
    let args' = List.map (fun (n, ty) -> n, lift_ty ctx' ty) args in
    let argtys = List.map (fun x -> lift_ty ctx' @@ snd x) args in
    let rty = lift_ty ctx' ty in
    let t = lift_tm ctx' t in
    let fnsig = List.fold_right (fun ty acc -> Ty_Arrow (ty, acc)) argtys rty in
    (thms, (f, Stmt) :: ctx, 
    Definition  { name = f ; 
                  isrec = isrec;
                  args = args' ; 
                  rty = rty ;
                  fnsig = fnsig ; 
                  body = t })
  | Print t -> (thms, ctx, Print (lift_tm ctx t))

let lift_program (p : Icparser.Parsed_ast.program) : program =
  let rec go thms ctx p =
    match p with
    | stmt :: p -> 
      let thms, ctx, stmt = lift_stmt thms ctx stmt in
      stmt :: go thms ctx p
    | [] -> []
  in go ["defn"] [] p

