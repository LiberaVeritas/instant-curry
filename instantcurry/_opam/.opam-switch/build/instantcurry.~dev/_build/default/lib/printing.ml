open Synint

(* pretty-printing utilities *)

let rec string_of_ty (ty : ty) : string =
  match ty with
  | Ty_Arrow (ty, ty') -> "(" ^ string_of_ty ty ^ " -> " ^ string_of_ty ty' ^ ")"
  | Ty_List ty -> "(" ^ string_of_ty ty ^ " list)" 
  | Ty_Nat -> "nat"

let rec string_of_tm (t : tm) : string =
  match t with
  | Nil ty -> "[] " ^ string_of_ty ty
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
  | BVar x -> "B" ^ x
  | Ref x -> "R" ^ x
  | MVar x -> "M" ^ x
  | UVar x -> "U" ^ x
