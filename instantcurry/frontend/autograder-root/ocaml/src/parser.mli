
(* The type of tokens. *)

type token = 
  | WTS
  | WITH
  | TYTREE
  | TYNAT
  | TYLST
  | TYARROW
  | TIMES
  | THEOREM
  | THEN
  | SEP
  | RPAR
  | RHS
  | REC
  | QED
  | PROOF
  | PRINT
  | PLUS
  | ON
  | NODE
  | NIL
  | NATLIT of (int)
  | MINUS
  | MATCH
  | LPAR
  | LHS
  | LET
  | INDUCTION
  | IH of (int)
  | IF0
  | IDENT of (string)
  | FUN
  | FORALL
  | EQ
  | EOF
  | END
  | EMPTY
  | ELSE
  | DEFINITION
  | DASH
  | CONS
  | COMMA
  | COLON
  | CASE
  | BY
  | BAR
  | AXIOM
  | ARROW

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Parsed_ast.program)
