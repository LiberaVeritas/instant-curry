open Synint
open Core
open Sexp
open Stdio

<<<<<<< HEAD

let stdout = Out_channel.stdout
let print s = output_hum stdout s; printf "\n"
=======
let stdout = Out_channel.stdout
let print _ = () (*output_hum stdout s; printf "\n"*)
>>>>>>> origin/main


(* typechecking *)

(* algo w 
types to type schemes, generalize (quantify) all free vars
when var is used, instantiate scheme to new type (replace quantified with fresh)
during inference, unify (enforce equality constraint) 
inference returns type and a substitution
recursive types should apply the substituion given at every level
when substituting, occurs check (don't sub var with type containing same var)
sub composition S1 . S2 is S1(S2 ty) is S1 applied to vars in S2
*)

let fresh : unit -> uv_name =
  let cnt = ref 0 in
  fun () -> 
    incr cnt;
    "t_" ^ Int.to_string !cnt;

type ty_scheme = {
  qvars : uv_name list;
  typ : ty;
} [@@deriving sexp]

exception IllTyped of string (* todo: MORE SPECIFIC TYPE ERRORS *) [@@deriving sexp]
type ctx = (name * ty_scheme) list [@@deriving sexp]
type thm_ctx = (name * thm_stmt) list [@@deriving sexp]


let lookup ctx x =
  List.Assoc.find ~equal:String.equal ctx x

let lookup_ty ctx x =
  match lookup ctx x with
  | Some sch -> Some sch.typ
  | None -> None

let member lst x =
  List.mem ~equal:String.equal lst x

  
let rec get_vars (ty: ty) : name list =
  match ty with
  | Ty_Var var -> [var]
  | Ty_Nat -> []
  | Ty_Arrow (t1, t2) -> get_vars t1 @ get_vars t2
  | Ty_List t' -> get_vars t'
  | Ty_Tree t' -> get_vars t'

(* type -> type scheme. Free vars get universally quantified *)
let generalize (gamma : ctx) (ty : ty) : ty_scheme =
  let vars = get_vars ty in
  let ctx_vars = List.map ~f:fst gamma in
  let qvars = vars |> List.filter ~f:(fun v -> not (member ctx_vars v)) in
  { qvars = qvars; typ = ty }
  
(* var -> type *)
type sub = (uv_name * ty) list [@@deriving sexp]
    
(* substitute variables withiin a given type with the matching type in the sub *)
let apply_sub (ty: ty) (sub : sub) : ty =
  let rec apply ty =
    match ty with 
    | Ty_Var var -> 
      begin match lookup sub var with
      | Some ty' -> ty'
      | None -> Ty_Var var
      end
    | Ty_Nat -> Ty_Nat
    | Ty_Arrow (t1, t2) -> Ty_Arrow (apply t1, apply t2)
    | Ty_List ty' -> Ty_List (apply ty')
    | Ty_Tree ty' -> Ty_Tree (apply ty')
  in
  apply ty
  
let apply_sub_sch (sch: ty_scheme) (sub: sub) : ty_scheme =
  let f (name, _) = not (member sch.qvars name) in
  let typ = apply_sub sch.typ (List.filter sub ~f:f) in
  { qvars = sch.qvars; typ = typ }
  
let apply_sub_ctx (ctx: ctx) (sub: sub) : ctx =
  let f (var, sch) = (var, apply_sub_sch sch sub) in 
  List.map ctx ~f:f

(* sub1(sub2 t) is (sub1 . sub2) t with same vars removed
ie. a -> b {a:c -> bool} {c:int} = a -> b {a:int -> bool}
TODO type error on same var to different types *)
let compose_sub (sub1: sub) (sub2: sub) : sub =
  let sub2' = List.map sub2 ~f:(fun (var, ty) -> (var, apply_sub ty sub1)) in
  let sub1' = List.filter sub1 ~f:(fun (var, _) -> 
    not (List.Assoc.mem sub2 var ~equal:String.equal)) in
  sub1' @ sub2'

(* type scheme -> type, replace all quantified vars with fresh vars *)
let instantiate (sch: ty_scheme) : ty =
  let f qv = (qv, Ty_Var (fresh ()) ) in
  apply_sub sch.typ (List.map sch.qvars ~f:f)

let unify_var (var: name) (ty: ty) : sub = 
  match ty with
  | Ty_Var v when String.equal v var -> []
  | ty -> if member (get_vars ty) var 
    then raise (IllTyped ("occurs check fail " ^ var ^ " " ^ (to_string (sexp_of_ty ty))))
    else [(var, ty)]
  
(* enforce equality constraint between types, unify to one type with same vars *)
let rec unify (t1: ty) (t2: ty) : sub =
  match (t1, t2) with
  | Ty_Nat, Ty_Nat -> []
  | Ty_Arrow (x1, y1), Ty_Arrow (x2, y2) ->
    let sub1 = unify x1 x2 in
    let sub2 = unify (apply_sub y1 sub1) (apply_sub y2 sub1) in
    compose_sub sub1 sub2
  | Ty_List t1, Ty_List t2 -> unify t1 t2
  | Ty_Tree t1, Ty_Tree t2 -> unify t1 t2
  | Ty_Var var, ty | ty, Ty_Var var -> unify_var var ty
  | _ -> raise (IllTyped ("unification error " ^ (to_string (sexp_of_ty t1)) ^ " " ^(to_string (sexp_of_ty t2))))
  
  
(* delta is metavars, sigma is refs, gamma is bound vars *)
let rec infer_tm (delta : ctx) (sigma : ctx) (gamma : ctx) (e : tm) : ty * sub =
  let inf = infer_tm delta sigma gamma in
<<<<<<< HEAD
  (*let () = print (sexp_of_tm e) in*)
=======
>>>>>>> origin/main
  match e with
  | Nil -> let var = Ty_Var (fresh ()) in (Ty_List var, [])
  | BVar x ->
    begin match lookup gamma x with 
    | Some sch -> (instantiate sch, [])
<<<<<<< HEAD
    | None -> raise (IllTyped ("no bvar " ^ x)) 
=======
    | None -> raise (IllTyped "no bvar") 
>>>>>>> origin/main
    end
  | MVar x -> 
    begin match lookup delta x with
    | Some sch -> (instantiate sch, [])
<<<<<<< HEAD
    | None -> raise (IllTyped ("no mvar " ^ x)) 
=======
    | None -> raise (IllTyped "no mvar") 
>>>>>>> origin/main
    end
  | Ref x -> 
    begin match lookup sigma x with
    | Some sch -> (instantiate sch, [])
    | None -> raise (IllTyped ("no ref " ^ x)) 
    end
  | UVar _ -> raise NotImplemented
  | Nat _ -> (Ty_Nat, [])
  | Plus (e, e') | Minus (e, e') | Times (e, e') -> 
    let sub1 = unify (fst (inf e)) Ty_Nat in
    let sub2 = unify (apply_sub (fst (inf e')) sub1) Ty_Nat in
    (Ty_Nat, compose_sub sub1 sub2)
  | If0 (e, z, nz) ->
    let (zty, _) = inf z in
    let (ety, _) = inf e in
    let (nzty, _) = inf nz in
    let sub1 = unify ety Ty_Nat in
    let sub2 = unify (apply_sub zty sub1) (apply_sub nzty sub1) in
    ((apply_sub zty sub1), compose_sub sub2 sub1)
  | Cons (x, xs) -> 
    let (xty, _) = inf x in
    let (xsty, _) = inf xs in
    let sub = unify (Ty_List xty) xsty in
    (Ty_List xty, sub)
  | App (f, arg) ->
    let rty = Ty_Var (fresh ()) in
    let (fty, sub1) = infer_tm delta sigma gamma f in
    let (argty, sub2) = infer_tm (apply_sub_ctx delta sub1)
                                 (apply_sub_ctx sigma sub1)
                                 (apply_sub_ctx gamma sub1)
                                 arg
    in
    let sub3 = unify (apply_sub fty sub2) (Ty_Arrow (argty, rty)) in
    let sub = compose_sub sub3 (compose_sub sub2 sub1) in
    (apply_sub rty sub, sub)
  | Fun (x, ty, e) ->
    let new_var = Ty_Var (fresh ()) in
    let (rty, sub1) = infer_tm delta sigma ((x, { qvars = []; typ = new_var }) :: gamma) e in
    let sub2 = unify ty (apply_sub new_var sub1) in
    let sub = compose_sub sub2 sub1 in
    (apply_sub rty sub, sub)
  | ListCase (l,nil,x,xs,e) -> 
    let new_var = Ty_Var (fresh ()) in
    let (lty, sub1) = inf l in
    let ty = apply_sub new_var sub1 in
    let sub2 = unify lty (Ty_List ty) in
    let (nilty, _) = inf nil in
    let gamma = apply_sub_ctx (
      (xs, {qvars = []; typ = Ty_List ty }) :: 
      (x, {qvars = []; typ = ty }) :: 
      gamma 
      ) sub2
    in
    let (ety, _) = infer_tm delta sigma gamma e in
    let sub3 = unify nilty ety in
    let sub = compose_sub sub3 (compose_sub sub2 sub1) in
    (apply_sub ety sub, sub)


<<<<<<< HEAD
let typecheck_claim (delta : ctx) (sigma : ctx) (c : claim) : unit =
  let inf tm = fst (infer_tm delta sigma [] tm) in
  let _ = unify (inf c.eqn.lhs) c.ty in
  let _ = unify (inf c.eqn.rhs) c.ty in
  ()

let typecheck_eqn (delta : ctx) (sigma : ctx) (eqn : eqn) : unit =
  let inf tm = fst (infer_tm delta sigma [] tm) in
  let _ = unify (inf eqn.lhs) (inf eqn.rhs) in
  ()
  
=======
let typecheck_eqn (delta : ctx) (sigma : ctx) (e : eqn) : unit =
  let inf tm = fst (infer_tm delta sigma [] tm) in
  let _ = unify (inf e.lhs) (inf e.rhs) in
  ()

>>>>>>> origin/main
let typecheck_step (delta : ctx) (sigma : ctx) 
                   (prev : tm) (next : tm) (_ : justification) : unit =
  let inf tm = fst (infer_tm delta sigma [] tm) in
  let _ = unify (inf prev) (inf next) in
  ()

let typecheck_steps (delta : ctx) (sigma : ctx) (s : side) : unit =
  let _ = List.fold_left s.steps ~init:s.start ~f:(fun prev (next, j) -> 
    typecheck_step delta sigma prev next j; next)
  in ()

let typecheck_case (delta : ctx) (sigma : ctx) (c : case) : unit =
  let delta = match c.pattern with (* todo: what if they induct on l but case is k = [] *)
  | Pat_cons (x, xs) -> 
    begin match lookup delta c.var with
    | Some { qvars = qvs; typ = (Ty_List ty as tyl) } -> 
      (x, { qvars = qvs; typ = ty }) :: (xs, { qvars = qvs; typ = tyl }) :: delta
    | Some { qvars = _; typ = _ } -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end
  | Pat_nil -> 
    begin match lookup delta c.var with
    | Some { qvars = _; typ = (Ty_List _) } -> delta
    | Some { qvars = _; typ = _ } -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end
  | Pat_empty -> raise (IllTyped "empty pattern") 
  | Pat_node (_, _, _) -> 
    begin match lookup delta c.var with
    | Some { qvars = _; typ = _ } -> raise (IllTyped "pattern disagrees with case var")
    | None -> raise (IllTyped "case on nonexistent var") end 
  in 
  (* todo: check wts is valid *)
  (* todo: check ihs are valid *)
<<<<<<< HEAD
  
  typecheck_eqn delta sigma c.wts;
=======

>>>>>>> origin/main
  if not (tm_equal (c.wts.lhs) (c.lhs.start)) then raise (IllTyped "invalid lhs start");
  typecheck_steps delta sigma c.lhs;
  if not (tm_equal (c.wts.rhs) (c.rhs.start)) then raise (IllTyped "invalid rhs start");
  typecheck_steps delta sigma c.rhs
  

let typecheck_proof (delta : ctx) (sigma : ctx) (p : proof) : unit =
  let _ = match p with (* todo: surely there is a nicer way to do this? *)
  | Proof (_, cases) -> List.map cases ~f:(typecheck_case delta sigma)
  | Axiom -> []
  in ()

let infer_stmt (delta : ctx) (sigma : ctx) (s : stmt) : ctx =
  let generalize = generalize sigma in
  let schemify (name, ty) = (name, generalize ty) in
  match s with
  | Definition d -> 
    let gamma = List.map d.args ~f:schemify in
    let sigma = (d.name, generalize d.fnsig) :: sigma in
    let (ty, sub1) = infer_tm delta sigma gamma d.body in
    let rty = (apply_sub d.rty sub1) in
    let _ = unify ty rty in 
    sigma
  | Print t -> 
    let _ = infer_tm delta sigma [] t in 
    sigma
  | Thm t ->  (* todo: add to context of theorems *)
    let delta = List.map t.stmt.quantifiers ~f:schemify in
<<<<<<< HEAD
    typecheck_claim delta sigma t.stmt.claim;
=======
    typecheck_eqn delta sigma t.stmt.claim;
>>>>>>> origin/main
    typecheck_proof delta sigma t.proof;
    sigma

let typecheck_prog (p : program) =
  List.fold ~f:(fun sigma stmt -> infer_stmt [] sigma stmt) ~init:[] p

(* TODO LIST
   
1. case analysis, get that [] and x :: xs are constructors of l
2. substitution of induction variables
3. generate IH
4. apply IH with congruence
    a. congruence over function application? is it needed?
*)

