open Synint
open Core
open Sexp
open Stdio

let stdout = Out_channel.stdout

(* typechecking *)

exception IllTyped of string (* todo: MORE SPECIFIC TYPE ERRORS *) 
type ctx = (name * ty) list [@@deriving sexp]
type thm_ctx = (name * thm_stmt) list [@@deriving sexp]

(* Delta: metavars, Sigma: Refs, Gamma: bvars *)
let rec typecheck_tm (delta : ctx) (sigma : ctx) (gamma : ctx) (e : tm) : ty =
  (* print_endline @@ Printing.string_of_tm e ; *)
  match e with
  (* | Nil ty -> Ty_List ty *)
  | Nil ->
  (*let () = output_hum stdout (sexp_of_tm e) in*)
  Ty_List Ty_Nat
  | Cons (x, xs) -> 
    let t = typecheck_tm delta sigma gamma x in
    begin match typecheck_tm delta sigma gamma xs with
    | Ty_List t' -> if ty_equal t t' then Ty_List t else raise (IllTyped "cons")
    | _ -> raise (IllTyped "cons")
    end
  | Nat _ -> Ty_Nat
  | Plus (e, e') | Minus (e, e') | Times (e, e') -> 
    begin match (typecheck_tm delta sigma gamma e, typecheck_tm delta sigma gamma e') with
    | (Ty_Nat, Ty_Nat) -> Ty_Nat
    | _ -> raise (IllTyped "arith non-nats")
    end
  | If0 (e, z, nz) ->
    let ty = typecheck_tm delta sigma gamma z in
    if phys_equal (typecheck_tm delta sigma gamma e) Ty_Nat &&
       phys_equal (typecheck_tm delta sigma gamma nz) ty then ty
    else raise (IllTyped "if0")
  | App (e, e') ->
    begin match typecheck_tm delta sigma gamma e with
    | Ty_Arrow (t, t') -> 
            let () = printf "\n" in
            let () = output_hum stdout (sexp_of_ty t) in
            let () = printf " -> " in
            let () = output_hum stdout (sexp_of_ty t') in
            let () = printf "\n" in
            let () = output_hum stdout (sexp_of_ty (typecheck_tm delta sigma gamma e')) in
            let () = printf "\n" in
      if ty_equal (typecheck_tm delta sigma gamma e') t
        then t' else raise (IllTyped ("apply other " ^ Sexp.to_string (sexp_of_ty (typecheck_tm delta sigma gamma e'))))
    | _ -> raise (IllTyped "apply non-fn")
    end
  | Fun (x, ty, e) ->
    let rty = typecheck_tm delta sigma ((x, ty) :: gamma) e in
    Ty_Arrow (ty, rty)
  | BVar x ->
    begin match List.Assoc.find ~equal:String.equal gamma x with
    | Some t -> t
    | None -> raise (IllTyped "no bvar") 
    end
  | MVar x -> 
    begin match List.Assoc.find ~equal:String.equal delta x with
    | Some t -> t
    | None -> raise (IllTyped "no mvar") 
    end
  | Ref x -> 
    begin match List.Assoc.find ~equal:String.equal sigma x with
    | Some t -> t
    | None -> raise (IllTyped "no ref") 
    end
  | UVar _ -> raise NotImplemented
  | ListCase (l,nil,x,xs,e) -> 
    begin match typecheck_tm delta sigma gamma l with
    | Ty_List t ->
      let _ = typecheck_tm delta sigma gamma nil in
      let gamma = (x, t) :: (xs, Ty_List t)  :: gamma in
      typecheck_tm delta sigma gamma e
    | _ -> raise (IllTyped ("scrutinee not list " ^ (Sexp.to_string (sexp_of_tm e))))
    end

let typecheck_eqn (delta : ctx) (sigma : ctx) (e : eqn) : unit =
  let tc = typecheck_tm delta sigma [] in
  if not (phys_equal (tc e.lhs) (tc e.rhs)) then raise (IllTyped "eqn types disagree")

let typecheck_step (delta : ctx) (sigma : ctx) 
                   (prev : tm) (next : tm) (_ : justification) : unit =
  let tc = typecheck_tm delta sigma [] in
  if not (phys_equal (tc prev) (tc next)) then raise (IllTyped "step types disagree")

let typecheck_steps (delta : ctx) (sigma : ctx) (s : side) : unit =
  let _ = List.fold_left s.steps ~init:s.start ~f:(fun prev (next, j) -> 
    typecheck_step delta sigma prev next j; next)
  in ()

let typecheck_case (delta : ctx) (sigma : ctx) (c : case) : unit =
  let delta = match c.pattern with (* todo: what if they induct on l but case is k = [] *)
  | Pat_cons (x, xs) -> 
    begin match List.Assoc.find ~equal:String.equal delta c.var with
    | Some (Ty_List ty as tyl) -> (x, ty) :: (xs, tyl) :: delta
    | Some _ -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end
  | Pat_nil -> 
    begin match List.Assoc.find ~equal:String.equal delta c.var with
    | Some (Ty_List _) -> delta
    | Some _ -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end
  | Pat_empty -> raise (IllTyped "empty pattern") 
  | Pat_node (_, _, _) -> 
    begin match List.Assoc.find ~equal:String.equal delta c.var with
    | Some _ -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end 
  in 
  (* todo: check wts is valid *)
  (* todo: check ihs are valid *)
  if not (phys_equal (c.wts.lhs) (c.lhs.start)) then raise (IllTyped "invalid lhs start");
  typecheck_steps delta sigma c.lhs;
  if not (phys_equal (c.wts.rhs) (c.rhs.start)) then raise (IllTyped "invalid rhs start");
  typecheck_steps delta sigma c.rhs
  

let typecheck_proof (delta : ctx) (sigma : ctx) (p : proof) : unit =
  let _ = match p with (* todo: surely there is a nicer way to do this? *)
  | Proof (_, cases) -> List.map cases ~f:(typecheck_case delta sigma)
  | Axiom -> []
  in ()

let typecheck_stmt (delta : ctx) (sigma : ctx) (s : stmt) : ctx =
  match s with
  | Definition d -> 
    (*let gamma = List.fold d.args ~init:[] ~f:(fun xs x -> x :: xs) in*)
    let gamma = d.args in(*
        let () = printf "asd\n" in
        let () = output_hum stdout (sexp_of_list (sexp_of_pair sexp_of_string sexp_of_ty) gamma) in
        let () = printf "\n" in*) 
    let sigma = (d.name, d.fnsig) :: sigma in
            
    let ty = typecheck_tm delta sigma gamma d.body in
    if ty_equal ty d.rty then sigma else raise (IllTyped "letrec disagree")
  | Print t -> 
    let _ = typecheck_tm delta sigma [] t in 
    sigma
  | Thm t ->  (* todo: add to context of theorems *)
    let delta = t.stmt.quantifiers @ delta in
    typecheck_eqn delta sigma t.stmt.claim;
    typecheck_proof delta sigma t.proof;
    sigma

let typecheck_prog (p : program) =
  List.fold ~f:(fun sigma stmt -> typecheck_stmt [] sigma stmt) ~init:[] p

(* TODO LIST
   
1. case analysis, get that [] and x :: xs are constructors of l
2. substitution of induction variables
3. generate IH
4. apply IH with congruence
    a. congruence over function application? is it needed?
*)

