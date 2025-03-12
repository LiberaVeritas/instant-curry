open Synint
open Core
open Lifting

open Printing

module P = Icparser.Parsed_ast

module Writer = struct 
	type 'a t = 'a * string
	
	let return x = (x, "")
	
	let bind m f =
	  let (x, s1) = m in
	  let (y, s2) = f x in
	  (y, s1 ^ "\n" ^ s2)
	
	let rec fmap f (lst: 'a t list) : 'a t list =
		match lst with
		| [] -> []
		| (x,l)::xs -> (f x, l) :: fmap f xs
	 
	let (let*) = bind
	let (>>=) = bind
end

let (let*) = Writer.bind

let out (_, s) = 
	Stdio.printf "%s\n" s

let log s = ((), s)

let append s (r, s') =
	(r, s' ^ s)

let prepend s (r, s') =
	(r, s ^ s')

let rec log_lift_ty ctx ty : ty Writer.t = 
	let lft = log_lift_ty ctx in
	let* () = log @@ "lifting type " ^ P.string_of_ty ty ^ ":" in
	  match ty with
	  | P.Ty_Nat -> (Ty_Nat, "nat")
	  | P.Ty_List ty -> let (t, s) = lft ty in (Ty_List t, s ^ " list")
	  | P.Ty_Arrow (ty, ty') -> 
	  	let (t1, s1) = lft ty in 
	  	let (t2, s2) = lft ty' in
	  	(Ty_Arrow (t1, t2), s1 ^ " -> " ^ s2)
	  | P.Ty_Tree ty -> let (t, s) = lft ty in (Ty_Tree t, s ^ " tree")
	  | P.Ty_Var v -> (Ty_Var v, "Var " ^ v)



let log_lift_tm (ctx : scope_ctx) (t : P.tm) : tm Writer.t =
	let res = lift_tm ctx t in
	let s = "lifted term " ^ P.string_of_tm t ^ " to " ^ string_of_tm res in
	(res, s)



    (* TODO *)
let log_lift_eqn (ctx : scope_ctx) (eqn : P.eqn) : eqn Writer.t =
  let (lhs, rhs) = eqn in
  let* () = log @@ "lifted eqn " ^ P.string_of_eqn eqn in
  Writer.return { lhs = lift_tm ctx lhs; rhs = lift_tm ctx rhs }

let lift_pat (pat : P.pattern) : pattern =
  match pat with
  | Pat_nil -> Pat_nil
  | Pat_cons (x, xs) -> Pat_cons (x, xs)
  | Pat_empty -> Pat_empty
  | Pat_node (l, x, r) -> Pat_node (l, x, r)

let lift_just (thms : name list) (just : P.name) : justification =
  if String.equal just "defn" then ByDefinition else
  if List.mem ~equal:String.equal thms just then ByTheorem just
  else raise (ScopeError just)

let lift_side (thms : name list) (ctx : scope_ctx) (side : P.side) : side =
  let (start, steps) = side in
  let start = lift_tm ctx start in
  let f = fun (tm, just) -> (lift_tm ctx tm, lift_just thms just) in
  { start = start;
    steps = List.map ~f:f steps }

let lift_case (thms : name list) (ctx : scope_ctx) (case : P.case) : case =
  let (name, pat, ihs, wts, lhs, rhs) = case in
    if not (match List.Assoc.find ~equal:String.equal ctx name with
      | Some Meta -> true
      | _ -> false
      )
    then raise (ScopeError name) else
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

let log_lift_proof (thms : name list) (ctx : scope_ctx) (prf : P.proof) =
	let* () = log @@ "lifted proof " ^ string_of_proof prf in
  match prf with 
  | Proof (var,_,cases) -> 
    begin match List.Assoc.find ~equal:String.equal ctx var with
    | Some Meta -> Writer.return @@ Proof (var, List.map ~f:(lift_case thms ctx) cases)
    | _ -> raise (ScopeError var)
    end
  | Axiom -> Writer.return Axiom

let log_lift_stmt (thms : name list) (ctx : scope_ctx) (stmt : P.stmt) : (name list * scope_ctx * stmt) Writer.t =
	Writer.return @@
  match stmt with
  | Theorem (name, args, claim, prf) -> 
    let ctx' = List.fold
                ~f:(fun ctx (x, _) -> (x, Meta) :: ctx)
                ~init:ctx
                args in
    let args = List.map ~f:(fun (x, ty) -> (x, fst @@ log_lift_ty ctx' ty)) args in
    let t = fst @@ log_lift_ty ctx' (snd claim) in
    let eqn = fst @@ log_lift_eqn ctx' (fst claim) in
    (name :: thms, ctx, Thm
                      { name = name;
                        stmt = { quantifiers = args; claim = {eqn=eqn; ty=t}};
                        proof = fst @@ log_lift_proof thms ctx' prf })
  | Definition (f, isrec, args, ty, t) -> 
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

let log_lift_program (p : P.program) =
  let rec go thms ctx p =
    match p with
    | stmt :: p -> 
      let ((thms, ctx, stmt), s) = log_lift_stmt thms ctx stmt in
      let (rest, s') = go thms ctx p in
      (stmt :: rest, s ^ s')
    | [] -> ([], "lifting program...\n")
  in go ["defn"] [] p


