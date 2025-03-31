open Synint
open Core

module P = Icparser.Parsed_ast

(* lifting from parse trees to ASTs *)

exception ScopeError of name 
type scope = Term | Stmt | Meta | Gen [@@deriving sexp]
type scope_ctx = (name * scope) list [@@deriving sexp]

let mem_assoc = List.Assoc.mem ~equal:String.equal

let rec lift_ty (ctx : scope_ctx) (ty : P.ty) : ty =
  let lft = lift_ty ctx in
  match ty with
  | P.Ty_Nat -> Ty_Nat
  | P.Ty_List ty -> Ty_List (lft ty)
  | P.Ty_Arrow (ty, ty') -> Ty_Arrow (lft ty, lft ty')
  (*| P.Ty_Tree ty -> Ty_Tree (lft ty)*)
  | P.Ty_Var v -> Ty_Var v

let rec lift_tm (ctx : scope_ctx) (t : P.tm) : tm =
  let lft = lift_tm ctx in
  match t with
  | P.Nil -> Nil
  | P.Cons (t, t') -> Cons (lft t, lft t')
  | P.ListCase (l, n, x, xs, c) -> 
    ListCase (lft l, lft n, x, xs, lift_tm ((x, Term) :: (xs, Term) :: ctx) c)
  | P.Nat n -> Nat n
  | P.Plus (t, t') -> Plus (lft t, lft t')
  | P.Minus (t, t') -> Minus (lft t, lft t')
  | P.Times (t, t') -> Times (lft t, lft t')
  | P.If0 (t, z, s) -> If0 (lft t, lft z, lft s)
  | P.App (t, t') -> App (lft t, lft t')
  | P.Fun (x, ty, t) -> Fun (x, (lift_ty ctx ty), lift_tm ((x, Term) :: ctx) t)
  (*| P.Empty -> Nil*)
  (*| P.Node (_, _, _) -> raise NotImplemented 
  | P.TreeCase _ -> raise NotImplemented*)
  | P.Var x -> 
    (*Sexp.output_hum Stdio.stdout @@ sexp_of_scope_ctx ctx;
    printf"\n\n";*)
    begin match List.Assoc.find ~equal:String.equal ctx x with
    | Some Term -> BVar x
    | Some Stmt -> Ref x
    | Some Meta -> MVar x
    | Some Gen -> UVar x
    | None -> raise (ScopeError x) 
    end
  (*| P.Empty -> raise NotImplemented*)

    (* TODO *)
let lift_eqn (ctx : scope_ctx) (eqn : P.eqn) : eqn =
  let (lhs, rhs) = eqn in
  { lhs = lift_tm ctx lhs; rhs = lift_tm ctx rhs }

let lift_pat (pat : P.pattern) : pattern =
  match pat with
  | Pat_nil -> Pat_nil
  | Pat_cons (x, xs) -> Pat_cons (x, xs)
  (*| Pat_empty -> Pat_empty*)
  (*| Pat_node (l, x, r) -> Pat_node (l, x, r)*)

let lift_just (thms : name list) (just : P.name) : justification =
  if String.equal just "defn" then (ByDefinition None) else 
    
  if String.is_prefix just ~prefix:"defn of" 
    then ByDefinition (Some (snd @@ String.rsplit2_exn ~on:' ' just)) else
  
  if String.equal just "commonsense" then ByCommonsense else
  (* TODO in parser.mly
  if String.equal just "common sense" then ByCommonsense else *)
  
  if String.equal just "eval" then ByEval else
  
  if String.is_prefix just ~prefix:"IH" then ByIH just else
  if List.mem ~equal:String.equal thms just then ByTheorem just 
  
  else raise (ScopeError ("theorem " ^ just ^ " not found"))

let lift_side (thms : name list) (ctx : scope_ctx) (side : P.side) : side =
  let (start, steps) = side in
  let start = lift_tm ctx start in
  let f = fun (tm, just) -> (lift_tm ctx tm, lift_just thms just) in
  { start = start;
    steps = List.map ~f:f steps }

(* generalized variables *)
let lift_ih ctx gen_vars ih =
  let generalize_var gvar (var, scope) =
    if String.equal gvar var then (var, Gen)
    else (var, scope)
  in
  let gen_helper gvar ctx =
    if mem_assoc ctx gvar then List.map ~f:(generalize_var gvar) ctx 
    else
    (gvar, Gen) :: ctx
  in
  let ih_ctx = List.fold ~f:(fun ctx gvar -> gen_helper gvar ctx) ~init:ctx gen_vars in
  lift_eqn ih_ctx ih

let lift_case (thms : name list) (ctx : scope_ctx) (stmt : thm_stmt) gen_vars (case : P.case) : case =
  let (name, pat, ihs, wts, lhs, rhs) = case in
    if not (match List.Assoc.find ~equal:String.equal ctx name with
      | Some Meta -> true
      | _ -> false
      )
    then raise (ScopeError name) else
  let ctx = match pat with
    | Pat_cons (x, xs) -> 
      (x, Meta) :: (xs, Meta) :: ctx  (* patterns introduce metavars *)
     (*| Pat_empty -> ctx*)
     (*| Pat_node (l, x, r) -> (l, Meta) :: (x, Meta) :: (r, Meta) :: ctx*)
     | Pat_nil -> ctx 
     in
  (*printf "\n%s\n\n" (Printing.string_of_eqn wts);*)
  let thms = List.fold ~f:(fun thms (n, _) -> n :: thms) ~init:thms ihs in  (* ihs introduce new thms *)
  let pat = lift_pat pat in
  let wts = (Option.map ~f:(lift_eqn ctx) wts) in
  let wts = Proof.infer_wts name pat wts stmt in
  { var = name;
    pattern = pat;
    ihs = List.map ~f:(function (name, ih) -> (name, lift_ih ctx gen_vars ih)) ihs; 
    wts = wts;
    lhs = lift_side thms ctx lhs;
    rhs = lift_side thms ctx rhs 
  }
  
let var_of (name, _, _, _, _, _) =
  name
  

let lift_proof (thms : name list) (ctx : scope_ctx) (stmt : thm_stmt) (prf : P.proof) : proof =
  match prf with 
  | Proof (var, gen_vars, cases) -> 
    if not (List.length cases = 2) then raise (ScopeError "there should be 2 cases")
    else (* TODO check there are 2 cases, one base and one list *)

    let gen_vars =
      match gen_vars with
      | None -> []
      | Some xs -> xs
    in
    (* check induction variables are same *)
    let ns = List.map ~f:var_of cases in
    let ns = List.map ~f:(String.equal var) ns in
    let res = List.fold ~f:(fun a b -> a && b ) ~init:true ns in
    if not res then raise (ScopeError "induction variables differ");
    
    begin match List.Assoc.find ~equal:String.equal ctx var with
    | Some Meta -> Proof (var, List.map ~f:(lift_case thms ctx stmt gen_vars) cases)
    | _ -> raise (ScopeError var)
    end
  | Axiom -> Axiom

let lift_stmt (thms : name list) (ctx : scope_ctx) (stmt : P.stmt) : name list * scope_ctx * stmt =
  match stmt with
  | Theorem (name, args, claim, prf) -> 
    if List.exists ~f:(String.equal name) thms then raise (ScopeError ("theorem " ^ name ^ " already stated")) else
    let ctx' = List.fold
                ~f:(fun ctx (x, _) -> (x, Meta) :: ctx)
                ~init:ctx
                args in
    let args = List.map ~f:(fun (x, ty) -> (x, lift_ty ctx' ty)) args in
    let t = lift_ty ctx' (snd claim) in
    let eqn = lift_eqn ctx' (fst claim) in
    let stmt = { quantifiers = args; claim = {eqn=eqn; ty=t}} in
    (name :: thms, ctx, Thm
                      { name = name;
                        stmt = stmt;
                        proof = lift_proof thms ctx' stmt prf })
  | Definition (f, isrec, args, ty, t) -> 
    if mem_assoc ctx f then raise (ScopeError (f ^ " already defined")) else
    let initial = 
      if isrec then (f, Stmt) :: ctx
      else ctx
    in
    let ctx' = List.fold 
              ~f:(fun ctx arg -> (fst arg, Term) :: ctx) 
              ~init:initial 
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
  | Const (_,_) -> raise NotImplemented (*(thms, (x, Stmt) :: ctx, Const (x, v))
  (*| NoOp -> (thms, ctx, Print Nil)*)*)

let lift_program (p : P.program) : program =
  let rec go thms ctx p =
    match p with
    | stmt :: p -> 
      let thms, ctx, stmt = lift_stmt thms ctx stmt in
      stmt :: go thms ctx p
    | [] -> []
  in go ["defn"] [] p

