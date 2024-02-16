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
  | Icparser.Parsed_ast.Nil ty -> Nil (lift_ty ctx ty)
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

let lift_stmt (ctx : scope_ctx) (stmt : Icparser.Parsed_ast.stmt) : scope_ctx * stmt =
  match stmt with
  | Theorem _ -> raise NotImplemented
  | Definition (f, isrec, args, ty, t) ->
    let ctx = List.fold_left 
              (fun ctx arg -> (fst arg, Term) :: ctx) 
              ((f, Stmt) :: ctx) 
              args in
    let args' = List.map (fun (n, ty) -> n, lift_ty ctx ty) args in
    let argtys = List.map (fun x -> lift_ty ctx @@ snd x) args in
    let rty = lift_ty ctx ty in
    let t = lift_tm ctx t in
    let fnsig = List.fold_right (fun ty acc -> Ty_Arrow (ty, acc)) argtys rty in
    (ctx, Definition 
          { name = f ; 
            isrec = isrec;
            args = args' ; 
            rty = rty ;
            fnsig = fnsig ; 
            body = t })
  | Print t -> (ctx, Print (lift_tm ctx t))

let lift_program (p : Icparser.Parsed_ast.program) : program =
  let rec go ctx p =
    match p with
    | stmt :: p -> 
      let ctx, stmt = lift_stmt ctx stmt in
      stmt :: go ctx p
    | [] -> []
  in go [] p

