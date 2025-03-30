open Core


type name = string [@@deriving sexp]
type uv_name = string [@@deriving sexp]
type isrec = bool [@@deriving sexp]

type ty =
  | Ty_Nat
  | Ty_Arrow of ty * ty
  | Ty_List of ty
  | Ty_Tree of ty
  | Ty_Var of string
  [@@deriving sexp]

let rec string_of_ty (ty : ty) : string =
  match ty with
  | Ty_Arrow (ty, ty') -> "(" ^ string_of_ty ty ^ " -> " ^ string_of_ty ty' ^ ")"
  | Ty_List ty -> "(" ^ string_of_ty ty ^ " list)" 
  | Ty_Nat -> "nat"
  | Ty_Tree ty -> "(" ^ string_of_ty ty ^ " tree)"
  | Ty_Var _ -> "var"

let fresh : unit -> ty =
  let cnt = ref 0 in
  fun () ->
    incr cnt;
    Ty_Var ("p_" ^ Int.to_string !cnt)

type tm =
  | Nil
  | Cons of tm * tm
  (*| Empty*)
  (*| Node of tm * tm * tm*)
  | ListCase of tm (* scrutinee *) * tm (* nil case *) * name * name * tm (* cons case (and its two bound vars) *)
  (*| TreeCase of tm (* scrutinee *) * tm (* empty case *) * name * name * name * tm (* node case (and its three bound vars) *)*)
  | Nat of int
  | Plus of tm * tm
  | Minus of tm * tm
  | Times of tm * tm
  | If0 of tm (* scrutinee *) * tm (* zero case *) * tm (* successor case *)
  | App of tm * tm
  | Fun of name * ty * tm (* anonymous function *)
  | Var of name (* we'll figure out which particular kind of variable later *)
  [@@deriving sexp]

let rec string_of_tm (tm : tm) : string =
  match tm with
  | Nil -> "[]"
 (*| Empty -> ""*)
  | Cons (t, t') -> "(" ^ string_of_tm t ^ " :: " ^ string_of_tm t' ^ ")"
  (*| Node _ -> "NODE"*)
  | ListCase (l, n, x, xs, c) ->
    "(match " ^ string_of_tm l ^ " with | nil -> " ^ string_of_tm n ^ 
    " | " ^ x ^ " :: " ^ xs ^ " -> " ^ string_of_tm c ^ ")"
  (*| TreeCase _ -> "TREECASE"*)
  | Nat n -> string_of_int n
  | Plus (t, t') -> "(" ^ string_of_tm t ^ " + " ^ string_of_tm t' ^ ")"
  | Minus (t, t') -> "(" ^ string_of_tm t ^ " - " ^ string_of_tm t' ^ ")"
  | Times (t, t') -> "(" ^ string_of_tm t ^ " * " ^ string_of_tm t' ^ ")"
  | If0 (t, z, s) -> "(if0 " ^ string_of_tm t ^ 
    " then " ^ string_of_tm z ^ " else " ^ string_of_tm s ^ ")"
  | App (t, t') -> "(" ^ string_of_tm t ^ " " ^ string_of_tm t' ^ ")"
  | Fun (x, ty, t) -> "(fun (" ^ x ^ " : " ^ string_of_ty ty ^ 
    ") -> " ^ string_of_tm t ^ ")"
  | Var x -> "Var " ^ x
  

type eqn = tm * tm [@@deriving sexp]

let string_of_eqn eqn = 
  let (t1, t2) = eqn in
  string_of_tm t1 ^ " = " ^ string_of_tm t2

type pattern = 
| Pat_nil (* [] *)
| Pat_cons of name * name (* x :: xs *)
(*| Pat_empty (* Empty *)*)
(*| Pat_node of name * name * name (* Node (l, x, r) *)*)
[@@deriving sexp]

type side = tm * (tm * name) list (* steps with justification *) [@@deriving sexp]

type case = name * pattern * 
            (name * eqn) list * 
            eqn option * 
            side * 
            side (* variable = pattern, optional induction hypotheses, wts, lhs, rhs *)
            [@@deriving sexp]

type proof = 
  | Proof of name * name list option * case list (* Induction variable, generalize vars, cases *)
  | Axiom
  [@@deriving sexp]

type stmt = 
  | Theorem of name * (name * ty) list * (eqn * ty) * proof (* Name, quant vars, statement with type, proof *)
  | Definition of name * isrec * (name * ty) list * ty * tm (* function name, typed args, return type, body *)
  (*TODO allow definition of vars to expressions *)
  | Print of tm (* Print result of evaluating term *)
  | Const of name * tm
  | NoOp (* for comments *)
  [@@deriving sexp]



type program = stmt list [@@deriving sexp]
