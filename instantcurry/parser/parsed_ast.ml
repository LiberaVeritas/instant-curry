type tm =
  | Nil
  | Cons of tm * tm
  | Nat of int
  | Plus of tm * tm
  | Eq of tm * tm
  | Var of string
  | App of tm * tm

type side = (tm * string) list (* steps with justification *)

type case = string * tm * 
            (string * tm) list option * 
            tm * 
            side * 
            side (* variable, pattern, induction hypotheses, wts, lhs, rhs *)

type proof = string * case list (* Induction variable, cases *)

type stmt = 
  | Theorem of string * tm * proof (* Name, statement, proof*)

type program = stmt list
