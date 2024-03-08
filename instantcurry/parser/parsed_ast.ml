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

type eqn = tm * tm

type pattern = 
| Pat_nil (* [] *)
| Pat_cons of name * name (* x :: xs *)
(* TODO: add patterns for Z and S n *)

type side = tm * (tm * name) list (* steps with justification *)

type case = name * pattern * 
            (name * eqn) list * 
            eqn * 
            side * 
            side (* variable = pattern, optional induction hypotheses, wts, lhs, rhs *)

type proof = 
  | Proof of name * case list (* Induction variable, cases *)
  | Axiom

type stmt = 
  | Theorem of name * (name * ty) list * eqn * proof (* Name, quant vars, statement, proof*)
  | Definition of name * bool * (name * ty) list * ty * tm (* function name, typed args, return type, body *)
  | Print of tm (* Print result of evaluating term *)

type program = stmt list
