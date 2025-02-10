open Synint
open Core


(* lifting from parse trees to ASTs *)

exception ScopeError of name
type scope = Term | Stmt | Meta [@@deriving sexp]
type scope_ctx = (name * scope) list [@@deriving sexp]

let rec lift_ty (ctx : scope_ctx) (ty : Icparser.Parsed_ast.ty) : ty =
  match ty with
  | Icparser.Parsed_ast.Ty_Nat -> Ty_Nat
  | Icparser.Parsed_ast.Ty_List ty -> Ty_List (lift_ty ctx ty)
  | Icparser.Parsed_ast.Ty_Arrow (ty, ty') -> Ty_Arrow (lift_ty ctx ty, lift_ty ctx ty')
  | Icparser.Parsed_ast.Ty_Tree ty -> Ty_Tree (lift_ty ctx ty)
  | Icparser.Parsed_ast.Ty_Var v -> Ty_Var v

let rec lift_tm (ctx : scope_ctx) (t : Icparser.Parsed_ast.tm) : tm =
  match t with
  | Icparser.Parsed_ast.Nil -> Nil
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
  (*| Icparser.Parsed_ast.Empty -> Nil*)
  | Icparser.Parsed_ast.Node (_, _, _) -> raise NotImplemented 
  | Icparser.Parsed_ast.TreeCase _ -> raise NotImplemented
  | Icparser.Parsed_ast.Var x -> 
    begin match List.Assoc.find ~equal:String.equal ctx x with
    | Some Term -> BVar x
    | Some Stmt -> Ref x
    | Some Meta -> MVar x
    | None -> raise (ScopeError x) 
    end
  | Icparser.Parsed_ast.Empty -> raise NotImplemented

    (* TODO *)
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
  if String.equal just "defn" then ByDefinition else
  if List.mem ~equal:String.equal thms just then ByTheorem just
  else raise (ScopeError just)

let lift_side (thms : name list) (ctx : scope_ctx) (side : Icparser.Parsed_ast.side) : side =
  let (start, steps) = side in
  let start = lift_tm ctx start in
  let f = fun (tm, just) -> (lift_tm ctx tm, lift_just thms just) in
  { start = start;
    steps = List.map ~f:f steps }

let lift_case (thms : name list) (ctx : scope_ctx) (case : Icparser.Parsed_ast.case) : case =
  let (name, pat, ihs, wts, lhs, rhs) = case in
  let ctx = match pat with
  | Pat_cons (x, xs) -> (x, Meta) :: (xs, Meta) :: ctx  (* patterns introduce metavars *)
  | Pat_empty -> ctx
  | Pat_node (l, x, r) -> (l, Meta) :: (x, Meta) :: (r, Meta) :: ctx
  | Pat_nil -> ctx 
  in
  let thms = List.fold ~f:(fun thms (n, _) -> n :: thms) ~init:thms ihs in  (* ihs introduce new thms *)
  { var = name;
    pattern = lift_pat pat;
    ihs = List.map ~f:(function (name, ih) -> (name, lift_eqn ctx ih)) ihs; 
    wts = lift_eqn ctx wts;
    lhs = lift_side thms ctx lhs;
    rhs = lift_side thms ctx rhs }

let lift_proof (thms : name list) (ctx : scope_ctx) (prf : Icparser.Parsed_ast.proof) : proof =
  match prf with 
  | Proof (var,_,cases) -> Proof (var, List.map ~f:(lift_case thms ctx) cases)
  | Axiom -> Axiom

let lift_stmt (thms : name list) (ctx : scope_ctx) (stmt : Icparser.Parsed_ast.stmt) : name list * scope_ctx * stmt =
  match stmt with
  | Theorem (name, args, claim, prf) -> 
    let ctx' = List.fold
                ~f:(fun ctx (x, _) -> (x, Meta) :: ctx)
                ~init:ctx
                args in
    let args = List.map ~f:(fun (x, ty) -> (x, lift_ty ctx' ty)) args in
    let claim = lift_eqn ctx' (fst claim) in
    (name :: thms, ctx, Thm
                      { name = name;
                        stmt = { quantifiers = args; claim = claim};
                        proof = lift_proof thms ctx' prf })
  | Definition (f, isrec, args, ty, t) -> (* TODO is rec *)
    let ctx' = List.fold 
              ~f:(fun ctx arg -> (fst arg, Term) :: ctx) 
              ~init:((f, Stmt) :: ctx) 
              args in
    let args' = List.map ~f:(fun (n, ty) -> n, lift_ty ctx' ty) args in
    let argtys = List.map ~f:snd args' in
    let rty = lift_ty ctx' ty in
    let t = lift_tm ctx' t in


    let fnsig = Base.List.fold_right ~f:(fun ty acc -> Ty_Arrow (ty, acc)) argtys ~init:rty in

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

