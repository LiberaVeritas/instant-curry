open Synint
open Core


(* pretty-printing utilities *)

let rec string_of_ty (ty : ty) : string =
  match ty with
  | Ty_Arrow (ty, ty') -> "(" ^ string_of_ty ty ^ " -> " ^ string_of_ty ty' ^ ")"
  | Ty_List ty -> "(" ^ string_of_ty ty ^ " list)" 
  | Ty_Nat -> "nat"
  | Ty_Tree ty -> "(" ^ string_of_ty ty ^ " tree)"
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
  | App (t, t') -> "(" ^ string_of_tm t ^ " " ^ string_of_tm t' ^ ")"
  | Fun (x, ty, t) -> "(fun (" ^ x ^ " : " ^ string_of_ty ty ^ 
    ") -> " ^ string_of_tm t ^ ")"
  | BVar x -> "B_" ^ x
  | Ref x -> "R_" ^ x
  | MVar x -> "M_" ^ x
  | UVar x -> "U_" ^ x
  
let string_of_args _ = "(args)"
let string_of_thm_stmt _ = "(thm stmt)"
let string_of_proof _ = "(proof)"

let string_of_eqn (eqn : eqn) =
  string_of_tm eqn.lhs ^ " = " ^ string_of_tm eqn.rhs

let string_of_stmt (s: stmt) : string =
  match s with 
  | Thm { name; stmt; proof } -> "Thm " ^ name ^ ":\n" ^ string_of_thm_stmt stmt ^ "\n" ^ string_of_proof proof
  | Definition { name; isrec=_; args; rty=_; fnsig; body } -> "Def " ^ name ^ ": " ^ string_of_ty fnsig ^ "\n" ^ string_of_args args ^ "\n" ^ string_of_tm body
  | Print tm -> string_of_tm tm

let string_of_prog (p: program) : string =
  List.fold ~f:(fun s s' -> s ^ "\n" ^ (string_of_stmt s')) ~init:"" p
  | BVar x -> "B" ^ x
  | Ref x -> "R" ^ x
  | MVar x -> "M" ^ x
  | UVar x -> "U" ^ x

