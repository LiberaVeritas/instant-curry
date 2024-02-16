type name = string
type uv_name = string

type ty =
  | Ty_Nat
  | Ty_Arrow of ty * ty
  | Ty_List of ty

type tm =
  | Nil of ty
  | Cons of tm * tm
  | ListCase of tm (* scrutinee *) * tm (* nil case *) * name * name * tm (* cons case (and its two bound vars) *)
  | Nat of int
  | Plus of tm * tm
  | Minus of tm * tm
  | Times of tm * tm
  | If0 of tm (* scrutinee *) * tm (* zero case *) * tm (* successor case *)
  | App of tm * tm
  | Fun of name * ty * tm (* anonymous function *)
  | Var of name (* we'll figure out which particular kind of variable later *)

type side = (tm * name) list (* steps with justification *)

type case = name * tm * 
            (name * tm) list option * 
            tm * 
            side * 
            side (* variable, pattern, induction hypotheses, wts, lhs, rhs *)

type proof = name * case list (* Induction variable, cases *)

type stmt = 
  | Theorem of name * tm * proof (* Name, statement, proof*)
  | Definition of name * bool * (name * ty) list * ty * tm (* function name, typed args, return type, body *)
  | Print of tm (* Print result of evaluating term *)

type program = stmt list
