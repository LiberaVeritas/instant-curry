open Synint
open Core


(* restore original variable name *)
let rec unrename e =
  let func x = 
    try fst @@ Core.String.lsplit2_exn ~on:'~' x
    with _ -> x
  in
  match e with
  | Nil -> e
  | Cons (x, xs) -> Cons (unrename x, unrename xs)
  | ListCase (l, n, x, xs, c) -> 
    ListCase (unrename l, unrename n, func x, func xs, unrename c)
  | Nat n -> Nat n
  | Plus (e, e') -> Plus (unrename e, unrename e')
  | Minus (e, e') -> Minus (unrename e, unrename e')
  | Times (e, e') -> Times (unrename e, unrename e')
  | If0 (e, z, nz) -> If0 (unrename e, unrename z, unrename nz)
  | App (f, e') -> App (unrename f, unrename e')
  | MApp (f, e') -> MApp (unrename f, unrename e')
  | Fun (f, ty, e) -> Fun (func f, ty, unrename e)
  | MFun (f, ty, e) -> MFun (func f, ty, unrename e)
  | BVar v -> BVar (func v)
  | UVar v -> UVar (func v)
  | Ref v -> Ref (func v)
  | MRef v -> MRef (func v)
  | MVar v -> MVar (func v)
  
  
(* pretty-printing utilities *)

let rec string_of_ty (ty : ty) : string =
  match ty with
  | Ty_Arrow (ty, ty') -> "(" ^ string_of_ty ty ^ " -> " ^ string_of_ty ty' ^ ")"
  | Ty_List ty -> "(" ^ string_of_ty ty ^ " list)" 
  | Ty_Nat -> "nat"
  (*| Ty_Tree ty -> "(" ^ string_of_ty ty ^ " tree)"*)
  | Ty_Var _ -> "var"

let rec string_of_tm (t : tm) : string =
  match t with
  (* | Nil ty -> "[] " ^ string_of_ty ty *)
  | Nil -> "[]"
  | Cons (t, t') -> "(" ^ string_of_tm t ^ " :: " ^ string_of_tm t' ^ ")"
  | ListCase (l, n, x, xs, c) ->
    "(match " ^ string_of_tm l ^ " with | nil -> " ^ string_of_tm n ^ 
    " | " ^ x ^ " :: " ^ xs ^ " -> " ^ string_of_tm c ^ ")"
  | Nat n -> string_of_int n
  | Plus (t, t') -> "(" ^ string_of_tm t ^ " + " ^ string_of_tm t' ^ ")"
  | Minus (t, t') -> "(" ^ string_of_tm t ^ " - " ^ string_of_tm t' ^ ")"
  | Times (t, t') -> "(" ^ string_of_tm t ^ " * " ^ string_of_tm t' ^ ")"
  | If0 (t, z, s) -> "(if0 " ^ string_of_tm t ^ 
    " then " ^ string_of_tm z ^ " else " ^ string_of_tm s ^ ")"
  | App (t, t') | MApp (t, t') -> 
    "(" ^ string_of_tm t ^ " " ^ string_of_tm t' ^ ")"
  | Fun (x, ty, t) | MFun (x, ty, t) -> 
    "(fun (" ^ x ^ " : " ^ string_of_ty ty ^ ") -> " ^ string_of_tm t ^ ")"
  | BVar x -> "B_" ^ x
  | Ref x | MRef x -> "R_" ^ x
  | MVar x -> "M_" ^ x
  | UVar x -> "U_" ^ x


  
let string_of_args _ = "(args)"
let string_of_thm_stmt _ = "(thm stmt)"
let string_of_proof _ = "(proof)"
let string_of_pattern pat =
  match pat with
  | Pat_nil -> "[]"
  | Pat_cons (n1, n2) -> n1 ^ " :: " ^ n2

let string_of_eqn (eqn : eqn) =
  string_of_tm eqn.lhs ^ " = " ^ string_of_tm eqn.rhs


let string_of_stmt (s: stmt) : string =
  match s with 
  | Thm { name; stmt; proof } -> "Thm " ^ name ^ ":\n" ^ string_of_thm_stmt stmt ^ "\n" ^ string_of_proof proof
  | Definition { name; isrec=_; args; rty=_; fnsig; body } -> "Def " ^ name ^ ": " ^ string_of_ty fnsig ^ "\n" ^ string_of_args args ^ "\n" ^ string_of_tm body
  | Print tm -> string_of_tm tm

let string_of_prog (p: program) : string =
  List.fold ~f:(fun s s' -> s ^ "\n" ^ (string_of_stmt s')) ~init:"" p
  

let output = Sexp.output_hum Stdio.stdout

(* more detailed sexp structure *)
let show_tm (e : tm) : unit =
  printf "\n";
  output (sexp_of_tm e);
  printf "\n\n";;

let show_eqn (e : eqn) =
  output (sexp_of_tm e.lhs);
  printf "\n=\n";
  output (sexp_of_tm e.rhs);


  
