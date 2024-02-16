open Synint

(* typechecking *)

exception IllTyped of string (* todo: MORE SPECIFIC TYPE ERRORS *)
type ctx = (name * ty) list

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
  | Thm _ -> raise NotImplemented

let typecheck_prog (p : program) =
  List.fold_left (fun sigma stmt -> typecheck_stmt [] sigma stmt) [] p
