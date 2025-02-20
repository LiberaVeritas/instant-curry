
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
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
    | NATLIT of (
# 45 "parser.mly"
       (int)
# 35 "parser.ml"
  )
    | MINUS
    | MATCH
    | LPAR
    | LHS
    | LET
    | INDUCTION
    | IH of (
# 19 "parser.mly"
       (int)
# 46 "parser.ml"
  )
    | IF0
    | IDENT of (
# 46 "parser.mly"
       (string)
# 52 "parser.ml"
  )
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
  
end

include MenhirBasics

# 1 "parser.mly"
  
    [@@@coverage exclude_file]
    open Parsed_ast

# 81 "parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_program) _menhir_state
    (** State 000.
        Stack shape : .
        Start symbol: program. *)

  | MenhirState006 : (('s, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 006.
        Stack shape : THEOREM IDENT.
        Start symbol: program. *)

  | MenhirState009 : (('s, _menhir_box_program) _menhir_cell1_LPAR _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 009.
        Stack shape : LPAR IDENT.
        Start symbol: program. *)

  | MenhirState011 : (('s, _menhir_box_program) _menhir_cell1_LPAR, _menhir_box_program) _menhir_state
    (** State 011.
        Stack shape : LPAR.
        Start symbol: program. *)

  | MenhirState015 : (('s, _menhir_box_program) _menhir_cell1_ty, _menhir_box_program) _menhir_state
    (** State 015.
        Stack shape : ty.
        Start symbol: program. *)

  | MenhirState021 : ((('s, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_state
    (** State 021.
        Stack shape : THEOREM IDENT nonempty_list(arg).
        Start symbol: program. *)

  | MenhirState023 : (('s, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_state
    (** State 023.
        Stack shape : NODE.
        Start symbol: program. *)

  | MenhirState026 : (('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_state
    (** State 026.
        Stack shape : MATCH.
        Start symbol: program. *)

  | MenhirState027 : (('s, _menhir_box_program) _menhir_cell1_LPAR, _menhir_box_program) _menhir_state
    (** State 027.
        Stack shape : LPAR.
        Start symbol: program. *)

  | MenhirState028 : (('s, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_state
    (** State 028.
        Stack shape : IF0.
        Start symbol: program. *)

  | MenhirState033 : (('s, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 033.
        Stack shape : FUN IDENT.
        Start symbol: program. *)

  | MenhirState036 : ((('s, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_ty, _menhir_box_program) _menhir_state
    (** State 036.
        Stack shape : FUN IDENT ty.
        Start symbol: program. *)

  | MenhirState038 : (((('s, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_ty, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 038.
        Stack shape : FUN IDENT ty tm.
        Start symbol: program. *)

  | MenhirState039 : ((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_TIMES, _menhir_box_program) _menhir_state
    (** State 039.
        Stack shape : tm TIMES.
        Start symbol: program. *)

  | MenhirState040 : (((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_TIMES, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 040.
        Stack shape : tm TIMES tm.
        Start symbol: program. *)

  | MenhirState041 : ((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 041.
        Stack shape : tm tm.
        Start symbol: program. *)

  | MenhirState042 : ((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_PLUS, _menhir_box_program) _menhir_state
    (** State 042.
        Stack shape : tm PLUS.
        Start symbol: program. *)

  | MenhirState043 : (((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_PLUS, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 043.
        Stack shape : tm PLUS tm.
        Start symbol: program. *)

  | MenhirState044 : ((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_MINUS, _menhir_box_program) _menhir_state
    (** State 044.
        Stack shape : tm MINUS.
        Start symbol: program. *)

  | MenhirState045 : (((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_MINUS, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 045.
        Stack shape : tm MINUS tm.
        Start symbol: program. *)

  | MenhirState047 : ((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_CONS, _menhir_box_program) _menhir_state
    (** State 047.
        Stack shape : tm CONS.
        Start symbol: program. *)

  | MenhirState048 : (((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_CONS, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 048.
        Stack shape : tm CONS tm.
        Start symbol: program. *)

  | MenhirState049 : ((('s, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 049.
        Stack shape : IF0 tm.
        Start symbol: program. *)

  | MenhirState050 : (((('s, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_THEN, _menhir_box_program) _menhir_state
    (** State 050.
        Stack shape : IF0 tm THEN.
        Start symbol: program. *)

  | MenhirState051 : ((((('s, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_THEN, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 051.
        Stack shape : IF0 tm THEN tm.
        Start symbol: program. *)

  | MenhirState052 : (((((('s, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_THEN, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_ELSE, _menhir_box_program) _menhir_state
    (** State 052.
        Stack shape : IF0 tm THEN tm ELSE.
        Start symbol: program. *)

  | MenhirState053 : ((((((('s, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_THEN, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_ELSE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 053.
        Stack shape : IF0 tm THEN tm ELSE tm.
        Start symbol: program. *)

  | MenhirState055 : ((('s, _menhir_box_program) _menhir_cell1_LPAR, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 055.
        Stack shape : LPAR tm.
        Start symbol: program. *)

  | MenhirState057 : ((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 057.
        Stack shape : MATCH tm.
        Start symbol: program. *)

  | MenhirState062 : (((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_state
    (** State 062.
        Stack shape : MATCH tm WITH option(BAR).
        Start symbol: program. *)

  | MenhirState063 : ((((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 063.
        Stack shape : MATCH tm WITH option(BAR) tm.
        Start symbol: program. *)

  | MenhirState068 : (((((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_BAR _menhir_cell0_IDENT _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 068.
        Stack shape : MATCH tm WITH option(BAR) tm BAR IDENT IDENT.
        Start symbol: program. *)

  | MenhirState069 : ((((((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_BAR _menhir_cell0_IDENT _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 069.
        Stack shape : MATCH tm WITH option(BAR) tm BAR IDENT IDENT tm.
        Start symbol: program. *)

  | MenhirState072 : (((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_state
    (** State 072.
        Stack shape : MATCH tm WITH option(BAR).
        Start symbol: program. *)

  | MenhirState073 : ((((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 073.
        Stack shape : MATCH tm WITH option(BAR) tm.
        Start symbol: program. *)

  | MenhirState083 : (((((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_BAR _menhir_cell0_IDENT _menhir_cell0_IDENT _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 083.
        Stack shape : MATCH tm WITH option(BAR) tm BAR IDENT IDENT IDENT.
        Start symbol: program. *)

  | MenhirState084 : ((((((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_BAR _menhir_cell0_IDENT _menhir_cell0_IDENT _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 084.
        Stack shape : MATCH tm WITH option(BAR) tm BAR IDENT IDENT IDENT tm.
        Start symbol: program. *)

  | MenhirState086 : ((('s, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 086.
        Stack shape : NODE tm.
        Start symbol: program. *)

  | MenhirState087 : (((('s, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_state
    (** State 087.
        Stack shape : NODE tm COMMA.
        Start symbol: program. *)

  | MenhirState088 : ((((('s, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 088.
        Stack shape : NODE tm COMMA tm.
        Start symbol: program. *)

  | MenhirState089 : (((((('s, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_state
    (** State 089.
        Stack shape : NODE tm COMMA tm COMMA.
        Start symbol: program. *)

  | MenhirState090 : ((((((('s, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 090.
        Stack shape : NODE tm COMMA tm COMMA tm.
        Start symbol: program. *)

  | MenhirState092 : (('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 092.
        Stack shape : tm.
        Start symbol: program. *)

  | MenhirState093 : ((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_state
    (** State 093.
        Stack shape : tm EQ.
        Start symbol: program. *)

  | MenhirState094 : (((('s, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 094.
        Stack shape : tm EQ tm.
        Start symbol: program. *)

  | MenhirState103 : (((('s, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_cell1_eqn _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 103.
        Stack shape : THEOREM IDENT nonempty_list(arg) eqn IDENT.
        Start symbol: program. *)

  | MenhirState121 : (('s, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_state
    (** State 121.
        Stack shape : CASE IDENT pattern.
        Start symbol: program. *)

  | MenhirState123 : (('s, _menhir_box_program) _menhir_cell1_IH, _menhir_box_program) _menhir_state
    (** State 123.
        Stack shape : IH.
        Start symbol: program. *)

  | MenhirState128 : ((('s, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_cell1_list_ih_, _menhir_box_program) _menhir_state
    (** State 128.
        Stack shape : CASE IDENT pattern list(ih).
        Start symbol: program. *)

  | MenhirState131 : (((('s, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_cell1_list_ih_, _menhir_box_program) _menhir_cell1_eqn, _menhir_box_program) _menhir_state
    (** State 131.
        Stack shape : CASE IDENT pattern list(ih) eqn.
        Start symbol: program. *)

  | MenhirState132 : (('s, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_state
    (** State 132.
        Stack shape : EQ.
        Start symbol: program. *)

  | MenhirState133 : ((('s, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 133.
        Stack shape : EQ tm.
        Start symbol: program. *)

  | MenhirState134 : (((('s, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_SEP, _menhir_box_program) _menhir_state
    (** State 134.
        Stack shape : EQ tm SEP.
        Start symbol: program. *)

  | MenhirState135 : (('s, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_state
    (** State 135.
        Stack shape : EQ.
        Start symbol: program. *)

  | MenhirState136 : ((('s, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 136.
        Stack shape : EQ tm.
        Start symbol: program. *)

  | MenhirState141 : (('s, _menhir_box_program) _menhir_cell1_step, _menhir_box_program) _menhir_state
    (** State 141.
        Stack shape : step.
        Start symbol: program. *)

  | MenhirState145 : ((((('s, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_cell1_list_ih_, _menhir_box_program) _menhir_cell1_eqn, _menhir_box_program) _menhir_cell1_side, _menhir_box_program) _menhir_state
    (** State 145.
        Stack shape : CASE IDENT pattern list(ih) eqn side.
        Start symbol: program. *)

  | MenhirState147 : (('s, _menhir_box_program) _menhir_cell1_ih, _menhir_box_program) _menhir_state
    (** State 147.
        Stack shape : ih.
        Start symbol: program. *)

  | MenhirState152 : (('s, _menhir_box_program) _menhir_cell1_case, _menhir_box_program) _menhir_state
    (** State 152.
        Stack shape : case.
        Start symbol: program. *)

  | MenhirState157 : (('s, _menhir_box_program) _menhir_cell1_arg, _menhir_box_program) _menhir_state
    (** State 157.
        Stack shape : arg.
        Start symbol: program. *)

  | MenhirState160 : (('s, _menhir_box_program) _menhir_cell1_PRINT, _menhir_box_program) _menhir_state
    (** State 160.
        Stack shape : PRINT.
        Start symbol: program. *)

  | MenhirState161 : ((('s, _menhir_box_program) _menhir_cell1_PRINT, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 161.
        Stack shape : PRINT tm.
        Start symbol: program. *)

  | MenhirState167 : (('s, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT, _menhir_box_program) _menhir_state
    (** State 167.
        Stack shape : DEFINITION IDENT.
        Start symbol: program. *)

  | MenhirState169 : ((('s, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_state
    (** State 169.
        Stack shape : DEFINITION IDENT nonempty_list(arg).
        Start symbol: program. *)

  | MenhirState171 : (((('s, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_cell1_ty, _menhir_box_program) _menhir_state
    (** State 171.
        Stack shape : DEFINITION IDENT nonempty_list(arg) ty.
        Start symbol: program. *)

  | MenhirState172 : ((((('s, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_cell1_ty, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_state
    (** State 172.
        Stack shape : DEFINITION IDENT nonempty_list(arg) ty tm.
        Start symbol: program. *)

  | MenhirState173 : (('s, _menhir_box_program) _menhir_cell1_stmt, _menhir_box_program) _menhir_state
    (** State 173.
        Stack shape : stmt.
        Start symbol: program. *)


and ('s, 'r) _menhir_cell1_arg = 
  | MenhirCell1_arg of 's * ('s, 'r) _menhir_state * (Parsed_ast.name * Parsed_ast.ty)

and ('s, 'r) _menhir_cell1_case = 
  | MenhirCell1_case of 's * ('s, 'r) _menhir_state * (Parsed_ast.case)

and ('s, 'r) _menhir_cell1_eqn = 
  | MenhirCell1_eqn of 's * ('s, 'r) _menhir_state * (Parsed_ast.eqn)

and ('s, 'r) _menhir_cell1_ih = 
  | MenhirCell1_ih of 's * ('s, 'r) _menhir_state * (Parsed_ast.name * Parsed_ast.eqn)

and ('s, 'r) _menhir_cell1_list_ih_ = 
  | MenhirCell1_list_ih_ of 's * ('s, 'r) _menhir_state * ((Parsed_ast.name * Parsed_ast.eqn) list)

and ('s, 'r) _menhir_cell1_nonempty_list_arg_ = 
  | MenhirCell1_nonempty_list_arg_ of 's * ('s, 'r) _menhir_state * ((Parsed_ast.name * Parsed_ast.ty) list)

and 's _menhir_cell0_option_BAR_ = 
  | MenhirCell0_option_BAR_ of 's * (unit option)

and 's _menhir_cell0_pattern = 
  | MenhirCell0_pattern of 's * (Parsed_ast.pattern)

and ('s, 'r) _menhir_cell1_side = 
  | MenhirCell1_side of 's * ('s, 'r) _menhir_state * (Parsed_ast.side)

and ('s, 'r) _menhir_cell1_step = 
  | MenhirCell1_step of 's * ('s, 'r) _menhir_state * (Parsed_ast.tm * Parsed_ast.name)

and ('s, 'r) _menhir_cell1_stmt = 
  | MenhirCell1_stmt of 's * ('s, 'r) _menhir_state * (Parsed_ast.stmt)

and ('s, 'r) _menhir_cell1_tm = 
  | MenhirCell1_tm of 's * ('s, 'r) _menhir_state * (Parsed_ast.tm)

and ('s, 'r) _menhir_cell1_ty = 
  | MenhirCell1_ty of 's * ('s, 'r) _menhir_state * (Parsed_ast.ty)

and ('s, 'r) _menhir_cell1_BAR = 
  | MenhirCell1_BAR of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_CASE = 
  | MenhirCell1_CASE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_COMMA = 
  | MenhirCell1_COMMA of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_CONS = 
  | MenhirCell1_CONS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_DEFINITION = 
  | MenhirCell1_DEFINITION of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_ELSE = 
  | MenhirCell1_ELSE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_EQ = 
  | MenhirCell1_EQ of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_FUN = 
  | MenhirCell1_FUN of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_IDENT = 
  | MenhirCell0_IDENT of 's * (
# 46 "parser.mly"
       (string)
# 487 "parser.ml"
)

and ('s, 'r) _menhir_cell1_IF0 = 
  | MenhirCell1_IF0 of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_IH = 
  | MenhirCell1_IH of 's * ('s, 'r) _menhir_state * (
# 19 "parser.mly"
       (int)
# 497 "parser.ml"
)

and ('s, 'r) _menhir_cell1_LPAR = 
  | MenhirCell1_LPAR of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_MATCH = 
  | MenhirCell1_MATCH of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_MINUS = 
  | MenhirCell1_MINUS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_NODE = 
  | MenhirCell1_NODE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_PLUS = 
  | MenhirCell1_PLUS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_PRINT = 
  | MenhirCell1_PRINT of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_SEP = 
  | MenhirCell1_SEP of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_THEN = 
  | MenhirCell1_THEN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_THEOREM = 
  | MenhirCell1_THEOREM of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_TIMES = 
  | MenhirCell1_TIMES of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_WITH = 
  | MenhirCell1_WITH of 's * ('s, 'r) _menhir_state

and _menhir_box_program = 
  | MenhirBox_program of (Parsed_ast.program) [@@unboxed]

let _menhir_action_01 =
  fun i t ->
    (
# 95 "parser.mly"
                                        ( (i, t) )
# 541 "parser.ml"
     : (Parsed_ast.name * Parsed_ast.ty))

let _menhir_action_02 =
  fun i ihs lhs p rhs wts ->
    (
# 109 "parser.mly"
                                        ( (i, p, ihs, wts, lhs, rhs) )
# 549 "parser.ml"
     : (Parsed_ast.case))

let _menhir_action_03 =
  fun t1 t2 ->
    (
# 130 "parser.mly"
                                        ( (t1, t2) )
# 557 "parser.ml"
     : (Parsed_ast.eqn))

let _menhir_action_04 =
  fun e id ->
    (
# 112 "parser.mly"
                                        ( ("IH" ^ string_of_int id, e) )
# 565 "parser.ml"
     : (Parsed_ast.name * Parsed_ast.eqn))

let _menhir_action_05 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 573 "parser.ml"
     : (Parsed_ast.case list))

let _menhir_action_06 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 581 "parser.ml"
     : (Parsed_ast.case list))

let _menhir_action_07 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 589 "parser.ml"
     : ((Parsed_ast.name * Parsed_ast.eqn) list))

let _menhir_action_08 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 597 "parser.ml"
     : ((Parsed_ast.name * Parsed_ast.eqn) list))

let _menhir_action_09 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 605 "parser.ml"
     : ((Parsed_ast.tm * Parsed_ast.name) list))

let _menhir_action_10 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 613 "parser.ml"
     : ((Parsed_ast.tm * Parsed_ast.name) list))

let _menhir_action_11 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 621 "parser.ml"
     : ((Parsed_ast.name * Parsed_ast.ty) list))

let _menhir_action_12 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 629 "parser.ml"
     : ((Parsed_ast.name * Parsed_ast.ty) list))

let _menhir_action_13 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 637 "parser.ml"
     : (unit option))

let _menhir_action_14 =
  fun x ->
    (
# 114 "<standard.mly>"
    ( Some x )
# 645 "parser.ml"
     : (unit option))

let _menhir_action_15 =
  fun () ->
    (
# 122 "parser.mly"
                                        ( Pat_nil )
# 653 "parser.ml"
     : (Parsed_ast.pattern))

let _menhir_action_16 =
  fun x xs ->
    (
# 123 "parser.mly"
                                        ( Pat_cons (x, xs) )
# 661 "parser.ml"
     : (Parsed_ast.pattern))

let _menhir_action_17 =
  fun () ->
    (
# 124 "parser.mly"
                                        ( Pat_empty )
# 669 "parser.ml"
     : (Parsed_ast.pattern))

let _menhir_action_18 =
  fun l r x ->
    (
# 127 "parser.mly"
                                        ( Pat_node (l, x, r) )
# 677 "parser.ml"
     : (Parsed_ast.pattern))

let _menhir_action_19 =
  fun _1 _2 ->
    (
# 82 "parser.mly"
                                        ( _1 :: _2 )
# 685 "parser.ml"
     : (Parsed_ast.program))

let _menhir_action_20 =
  fun () ->
    (
# 83 "parser.mly"
                                        ( [] )
# 693 "parser.ml"
     : (Parsed_ast.program))

let _menhir_action_21 =
  fun cs i ->
    (
# 100 "parser.mly"
                                        ( Proof (i, cs) )
# 701 "parser.ml"
     : (Parsed_ast.proof))

let _menhir_action_22 =
  fun () ->
    (
# 101 "parser.mly"
                                        ( Axiom )
# 709 "parser.ml"
     : (Parsed_ast.proof))

let _menhir_action_23 =
  fun steps t ->
    (
# 116 "parser.mly"
                                        ( (t, steps) )
# 717 "parser.ml"
     : (Parsed_ast.side))

let _menhir_action_24 =
  fun i t ->
    (
# 119 "parser.mly"
                                        ( (t, i) )
# 725 "parser.ml"
     : (Parsed_ast.tm * Parsed_ast.name))

let _menhir_action_25 =
  fun c p ps v ->
    (
# 88 "parser.mly"
                                        ( Theorem (v, ps, c, p) )
# 733 "parser.ml"
     : (Parsed_ast.stmt))

let _menhir_action_26 =
  fun f ps t ty ->
    (
# 91 "parser.mly"
                                        ( Definition (f, true, ps, ty, t) )
# 741 "parser.ml"
     : (Parsed_ast.stmt))

let _menhir_action_27 =
  fun t ->
    (
# 92 "parser.mly"
                                        ( Print t )
# 749 "parser.ml"
     : (Parsed_ast.stmt))

let _menhir_action_28 =
  fun () ->
    (
# 133 "parser.mly"
                                        ( Nil )
# 757 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_29 =
  fun t1 t2 ->
    (
# 134 "parser.mly"
                                        ( Cons (t1, t2) )
# 765 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_30 =
  fun () ->
    (
# 135 "parser.mly"
                                        ( Empty )
# 773 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_31 =
  fun l r x ->
    (
# 138 "parser.mly"
                                        ( Node (l, x, r) )
# 781 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_32 =
  fun l t1 t2 x xs ->
    (
# 142 "parser.mly"
                                        ( ListCase (l, t1, x, xs, t2) )
# 789 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_33 =
  fun l r t t1 t2 x ->
    (
# 148 "parser.mly"
                                        ( TreeCase (t, t1, l, x, r, t2) )
# 797 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_34 =
  fun _1 ->
    (
# 149 "parser.mly"
                                        ( Nat _1 )
# 805 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_35 =
  fun t1 t2 ->
    (
# 150 "parser.mly"
                                        ( Plus (t1, t2) )
# 813 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_36 =
  fun t1 t2 ->
    (
# 151 "parser.mly"
                                        ( Minus (t1, t2) )
# 821 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_37 =
  fun t1 t2 ->
    (
# 152 "parser.mly"
                                        ( Times (t1, t2) )
# 829 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_38 =
  fun t t1 t2 ->
    (
# 154 "parser.mly"
                                        ( If0 (t, t1, t2) )
# 837 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_39 =
  fun t1 t2 ->
    (
# 155 "parser.mly"
                                        ( App (t1, t2) )
# 845 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_40 =
  fun t ty x ->
    (
# 157 "parser.mly"
                                        ( Fun (x, ty, t) )
# 853 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_41 =
  fun _1 ->
    (
# 158 "parser.mly"
                                        ( Var _1 )
# 861 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_42 =
  fun t ->
    (
# 159 "parser.mly"
                                        ( t )
# 869 "parser.ml"
     : (Parsed_ast.tm))

let _menhir_action_43 =
  fun () ->
    (
# 162 "parser.mly"
                                        ( Ty_Nat )
# 877 "parser.ml"
     : (Parsed_ast.ty))

let _menhir_action_44 =
  fun t1 t2 ->
    (
# 163 "parser.mly"
                                        ( Ty_Arrow (t1, t2) )
# 885 "parser.ml"
     : (Parsed_ast.ty))

let _menhir_action_45 =
  fun t ->
    (
# 164 "parser.mly"
                                        ( Ty_List t )
# 893 "parser.ml"
     : (Parsed_ast.ty))

let _menhir_action_46 =
  fun t ->
    (
# 165 "parser.mly"
                                        ( Ty_Tree t )
# 901 "parser.ml"
     : (Parsed_ast.ty))

let _menhir_action_47 =
  fun t ->
    (
# 166 "parser.mly"
                                        ( t )
# 909 "parser.ml"
     : (Parsed_ast.ty))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | ARROW ->
        "ARROW"
    | AXIOM ->
        "AXIOM"
    | BAR ->
        "BAR"
    | BY ->
        "BY"
    | CASE ->
        "CASE"
    | COLON ->
        "COLON"
    | COMMA ->
        "COMMA"
    | CONS ->
        "CONS"
    | DASH ->
        "DASH"
    | DEFINITION ->
        "DEFINITION"
    | ELSE ->
        "ELSE"
    | EMPTY ->
        "EMPTY"
    | END ->
        "END"
    | EOF ->
        "EOF"
    | EQ ->
        "EQ"
    | FORALL ->
        "FORALL"
    | FUN ->
        "FUN"
    | IDENT _ ->
        "IDENT"
    | IF0 ->
        "IF0"
    | IH _ ->
        "IH"
    | INDUCTION ->
        "INDUCTION"
    | LET ->
        "LET"
    | LHS ->
        "LHS"
    | LPAR ->
        "LPAR"
    | MATCH ->
        "MATCH"
    | MINUS ->
        "MINUS"
    | NATLIT _ ->
        "NATLIT"
    | NIL ->
        "NIL"
    | NODE ->
        "NODE"
    | ON ->
        "ON"
    | PLUS ->
        "PLUS"
    | PRINT ->
        "PRINT"
    | PROOF ->
        "PROOF"
    | QED ->
        "QED"
    | REC ->
        "REC"
    | RHS ->
        "RHS"
    | RPAR ->
        "RPAR"
    | SEP ->
        "SEP"
    | THEN ->
        "THEN"
    | THEOREM ->
        "THEOREM"
    | TIMES ->
        "TIMES"
    | TYARROW ->
        "TYARROW"
    | TYLST ->
        "TYLST"
    | TYNAT ->
        "TYNAT"
    | TYTREE ->
        "TYTREE"
    | WITH ->
        "WITH"
    | WTS ->
        "WTS"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_175 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_program =
    fun _menhir_stack _v ->
      MenhirBox_program _v
  
  let rec _menhir_goto_program : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_175 _menhir_stack _v
      | MenhirState173 ->
          _menhir_run_174 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_174 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_stmt -> _ -> _menhir_box_program =
    fun _menhir_stack _v ->
      let MenhirCell1_stmt (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_19 _1 _2 in
      _menhir_goto_program _menhir_stack _v _menhir_s
  
  let _menhir_run_162 : type  ttv_stack. ttv_stack -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_s ->
      let _v = _menhir_action_20 () in
      _menhir_goto_program _menhir_stack _v _menhir_s
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_THEOREM (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | RPAR ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | SEP ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | FORALL ->
                          let _menhir_s = MenhirState006 in
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | LPAR ->
                              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_007 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAR (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _menhir_s = MenhirState009 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | TYNAT ->
                  _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LPAR ->
                  _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_010 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_43 () in
      _menhir_goto_ty _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_ty : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState169 ->
          _menhir_run_170 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState033 ->
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState009 ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState015 ->
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState011 ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_170 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TYTREE ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYLST ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYARROW ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_s = MenhirState171 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_013 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ty -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_ty (_menhir_stack, _menhir_s, t) = _menhir_stack in
      let _v = _menhir_action_46 t in
      _menhir_goto_ty _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_014 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ty -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_ty (_menhir_stack, _menhir_s, t) = _menhir_stack in
      let _v = _menhir_action_45 t in
      _menhir_goto_ty _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_015 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ty -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState015 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TYNAT ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_011 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState011 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TYNAT ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_022 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NODE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _menhir_s = MenhirState023 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_024 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_28 () in
      _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_tm : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState171 ->
          _menhir_run_172 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState160 ->
          _menhir_run_161 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState135 ->
          _menhir_run_136 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState093 ->
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState128 ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState123 ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState021 ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState089 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState087 ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState023 ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState068 ->
          _menhir_run_069 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState026 ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState027 ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState052 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState050 ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState028 ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState047 ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState044 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState042 ->
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState172 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState161 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState133 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState136 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState092 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState094 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState086 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState088 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState090 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState057 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState073 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState084 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState063 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState069 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState055 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState049 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState051 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState053 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState038 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState048 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState045 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState043 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState041 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState040 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState039 ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState036 ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_172 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_cell1_ty as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState172
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState172
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState172
      | DEFINITION | EOF | PRINT | THEOREM ->
          let MenhirCell1_ty (_menhir_stack, _, ty) = _menhir_stack in
          let MenhirCell1_nonempty_list_arg_ (_menhir_stack, _, ps) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, f) = _menhir_stack in
          let MenhirCell1_DEFINITION (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_26 f ps t ty in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_039 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_tm as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_TIMES (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState039 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_025 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_34 _1 in
      _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_026 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_MATCH (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState026 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_027 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState027 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_028 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_IF0 (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState028 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_029 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_41 _1 in
      _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_030 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FUN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | COLON ->
                  let _menhir_s = MenhirState033 in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | TYNAT ->
                      _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | LPAR ->
                      _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_037 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_30 () in
      _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_042 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_tm as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_PLUS (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState042 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_044 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_tm as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_MINUS (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState044 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_047 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_tm as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_CONS (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState047 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_stmt : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_stmt (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | THEOREM ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState173
      | PRINT ->
          _menhir_run_159 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState173
      | EOF ->
          _menhir_run_162 _menhir_stack MenhirState173
      | DEFINITION ->
          _menhir_run_163 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState173
      | _ ->
          _eRR ()
  
  and _menhir_run_159 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_PRINT (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SEP ->
          let _menhir_s = MenhirState160 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_163 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_DEFINITION (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SEP ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LET ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | REC ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | IDENT _v ->
                      let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
                      let _menhir_s = MenhirState167 in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | LPAR ->
                          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_161 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_PRINT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState161
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState161
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | DEFINITION | EOF | PRINT | THEOREM ->
          let MenhirCell1_PRINT (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_27 t in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_136 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_EQ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState136
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState136
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | DASH ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BY ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | IDENT _v_2 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | SEP ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      let MenhirCell1_EQ (_menhir_stack, _menhir_s) = _menhir_stack in
                      let (t, i) = (_v, _v_2) in
                      let _v = _menhir_action_24 i t in
                      let _menhir_stack = MenhirCell1_step (_menhir_stack, _menhir_s, _v) in
                      (match (_tok : MenhirBasics.token) with
                      | EQ ->
                          _menhir_run_135 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState141
                      | CASE | QED | RHS ->
                          let _v_0 = _menhir_action_09 () in
                          _menhir_run_142 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState136
      | _ ->
          _eRR ()
  
  and _menhir_run_135 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_EQ (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState135 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_142 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_step -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_step (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_10 x xs in
      _menhir_goto_list_step_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_list_step_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState134 ->
          _menhir_run_143 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState141 ->
          _menhir_run_142 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_143 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_EQ, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_SEP -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_SEP (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_tm (_menhir_stack, _, t) = _menhir_stack in
      let MenhirCell1_EQ (_menhir_stack, _menhir_s) = _menhir_stack in
      let steps = _v in
      let _v = _menhir_action_23 steps t in
      _menhir_goto_side _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_side : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState145 ->
          _menhir_run_146 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState131 ->
          _menhir_run_144 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_146 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_cell1_list_ih_, _menhir_box_program) _menhir_cell1_eqn, _menhir_box_program) _menhir_cell1_side -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_side (_menhir_stack, _, lhs) = _menhir_stack in
      let MenhirCell1_eqn (_menhir_stack, _, wts) = _menhir_stack in
      let MenhirCell1_list_ih_ (_menhir_stack, _, ihs) = _menhir_stack in
      let MenhirCell0_pattern (_menhir_stack, p) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, i) = _menhir_stack in
      let MenhirCell1_CASE (_menhir_stack, _menhir_s) = _menhir_stack in
      let rhs = _v in
      let _v = _menhir_action_02 i ihs lhs p rhs wts in
      let _menhir_stack = MenhirCell1_case (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | CASE ->
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState152
      | QED ->
          let _v_0 = _menhir_action_05 () in
          _menhir_run_153 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_104 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_CASE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQ ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NODE ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | LPAR ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | IDENT _v_0 ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | COMMA ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | IDENT _v_1 ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | COMMA ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | IDENT _v_2 ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | RPAR ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              let (r, x, l) = (_v_2, _v_1, _v_0) in
                                              let _v = _menhir_action_18 l r x in
                                              _menhir_goto_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | NIL ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let _v = _menhir_action_15 () in
                  _menhir_goto_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
              | IDENT _v_5 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | CONS ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | IDENT _v_6 ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          let (x, xs) = (_v_5, _v_6) in
                          let _v = _menhir_action_16 x xs in
                          _menhir_goto_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | EMPTY ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let _v = _menhir_action_17 () in
                  _menhir_goto_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_pattern : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_pattern (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | SEP ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IH _v_0 ->
              _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState121
          | WTS ->
              let _v_1 = _menhir_action_07 () in
              _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState121
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_122 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_IH (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState123 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_126 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_list_ih_ (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState128 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_153 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_case -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_case (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_06 x xs in
      _menhir_goto_list_case_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_case_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState152 ->
          _menhir_run_153 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState103 ->
          _menhir_run_149 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_149 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_cell1_eqn _menhir_cell0_IDENT -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SEP ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, i) = _menhir_stack in
          let cs = _v in
          let _v = _menhir_action_21 cs i in
          _menhir_goto_proof _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_proof : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_, _menhir_box_program) _menhir_cell1_eqn -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_eqn (_menhir_stack, _, c) = _menhir_stack in
      let MenhirCell1_nonempty_list_arg_ (_menhir_stack, _, ps) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, v) = _menhir_stack in
      let MenhirCell1_THEOREM (_menhir_stack, _menhir_s) = _menhir_stack in
      let p = _v in
      let _v = _menhir_action_25 c p ps v in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_144 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_cell1_list_ih_, _menhir_box_program) _menhir_cell1_eqn as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_side (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | RHS ->
          let _menhir_s = MenhirState145 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQ ->
              _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_132 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_EQ (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState132 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_133 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_EQ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | SEP ->
          let _menhir_stack = MenhirCell1_SEP (_menhir_stack, MenhirState133) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQ ->
              _menhir_run_135 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState134
          | CASE | QED | RHS ->
              let _v_0 = _menhir_action_09 () in
              _menhir_run_143 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
          | _ ->
              _eRR ())
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | NATLIT _v_1 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState133
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | IDENT _v_2 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState133
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState133
      | _ ->
          _eRR ()
  
  and _menhir_run_094 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_EQ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState094
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState094
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | SEP ->
          let MenhirCell1_EQ (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _menhir_s, t1) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_03 t1 t2 in
          _menhir_goto_eqn _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_eqn : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState128 ->
          _menhir_run_129 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState123 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState021 ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_129 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_CASE _menhir_cell0_IDENT _menhir_cell0_pattern, _menhir_box_program) _menhir_cell1_list_ih_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_eqn (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LHS ->
          let _menhir_s = MenhirState131 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQ ->
              _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_124 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_IH -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_IH (_menhir_stack, _menhir_s, id) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_04 e id in
      let _menhir_stack = MenhirCell1_ih (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | IH _v_0 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState147
      | WTS ->
          let _v_1 = _menhir_action_07 () in
          _menhir_run_148 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1
      | _ ->
          _eRR ()
  
  and _menhir_run_148 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ih -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_ih (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_08 x xs in
      _menhir_goto_list_ih_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_ih_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState147 ->
          _menhir_run_148 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState121 ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_095 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_nonempty_list_arg_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_eqn (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PROOF ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SEP ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | BY ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | INDUCTION ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | ON ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | IDENT _v_0 ->
                              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v_0) in
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | SEP ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | CASE ->
                                      _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState103
                                  | QED ->
                                      let _v_1 = _menhir_action_05 () in
                                      _menhir_run_149 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | AXIOM ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SEP ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_22 () in
              _menhir_goto_proof _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_092 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | NATLIT _v_0 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState092
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | IDENT _v_1 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState092
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | EQ ->
          let _menhir_stack = MenhirCell1_EQ (_menhir_stack, MenhirState092) in
          let _menhir_s = MenhirState093 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | _ ->
          _eRR ()
  
  and _menhir_run_090 : type  ttv_stack. ((((((ttv_stack, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_COMMA (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, x) = _menhir_stack in
          let MenhirCell1_COMMA (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, l) = _menhir_stack in
          let MenhirCell1_NODE (_menhir_stack, _menhir_s) = _menhir_stack in
          let r = _v in
          let _v = _menhir_action_31 l r x in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState090
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState090
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | _ ->
          _eRR ()
  
  and _menhir_run_088 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_NODE, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_COMMA as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | NATLIT _v_0 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState088
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | IDENT _v_1 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState088
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
      | COMMA ->
          let _menhir_stack = MenhirCell1_COMMA (_menhir_stack, MenhirState088) in
          let _menhir_s = MenhirState089 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_086 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_NODE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | NATLIT _v_0 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState086
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | IDENT _v_1 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState086
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | COMMA ->
          let _menhir_stack = MenhirCell1_COMMA (_menhir_stack, MenhirState086) in
          let _menhir_s = MenhirState087 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_084 : type  ttv_stack. ((((((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_BAR _menhir_cell0_IDENT _menhir_cell0_IDENT _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState084
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState084
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | END ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, r) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, x) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, l) = _menhir_stack in
          let MenhirCell1_BAR (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, t1) = _menhir_stack in
          let MenhirCell0_option_BAR_ (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_WITH (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, t) = _menhir_stack in
          let MenhirCell1_MATCH (_menhir_stack, _menhir_s) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_33 l r t t1 t2 x in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | _ ->
          _eRR ()
  
  and _menhir_run_073 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | NATLIT _v_0 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState073
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | IDENT _v_1 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState073
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | BAR ->
          let _menhir_stack = MenhirCell1_BAR (_menhir_stack, MenhirState073) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LPAR ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | IDENT _v ->
                      let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | COMMA ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | IDENT _v ->
                              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | COMMA ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | IDENT _v ->
                                      let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | RPAR ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | ARROW ->
                                              let _menhir_s = MenhirState083 in
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              (match (_tok : MenhirBasics.token) with
                                              | NODE ->
                                                  _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | NIL ->
                                                  _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | NATLIT _v ->
                                                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                                              | MATCH ->
                                                  _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | LPAR ->
                                                  _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | IF0 ->
                                                  _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | IDENT _v ->
                                                  _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                                              | FUN ->
                                                  _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | EMPTY ->
                                                  _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                                              | _ ->
                                                  _eRR ())
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_069 : type  ttv_stack. ((((((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_BAR _menhir_cell0_IDENT _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState069
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState069
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | END ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, xs) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, x) = _menhir_stack in
          let MenhirCell1_BAR (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, t1) = _menhir_stack in
          let MenhirCell0_option_BAR_ (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_WITH (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, l) = _menhir_stack in
          let MenhirCell1_MATCH (_menhir_stack, _menhir_s) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_32 l t1 t2 x xs in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH _menhir_cell0_option_BAR_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | NATLIT _v_0 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState063
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | IDENT _v_1 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState063
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | BAR ->
          let _menhir_stack = MenhirCell1_BAR (_menhir_stack, MenhirState063) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | CONS ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | IDENT _v ->
                      let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | ARROW ->
                          let _menhir_s = MenhirState068 in
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | NODE ->
                              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | NIL ->
                              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | NATLIT _v ->
                              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                          | MATCH ->
                              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | LPAR ->
                              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | IF0 ->
                              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | IDENT _v ->
                              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                          | FUN ->
                              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | EMPTY ->
                              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_057 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | WITH ->
          let _menhir_stack = MenhirCell1_WITH (_menhir_stack, MenhirState057) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = () in
              let _v = _menhir_action_14 x in
              _menhir_goto_option_BAR_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | EMPTY | NIL ->
              let _v = _menhir_action_13 () in
              _menhir_goto_option_BAR_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | _ ->
              _eRR ())
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | NATLIT _v_2 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState057
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | IDENT _v_3 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState057
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
      | _ ->
          _eRR ()
  
  and _menhir_goto_option_BAR_ : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_WITH -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_option_BAR_ (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | NIL ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ARROW ->
              let _menhir_s = MenhirState062 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NODE ->
                  _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NIL ->
                  _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NATLIT _v ->
                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | MATCH ->
                  _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LPAR ->
                  _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IF0 ->
                  _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FUN ->
                  _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | EMPTY ->
                  _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | EMPTY ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ARROW ->
              let _menhir_s = MenhirState072 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NODE ->
                  _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NIL ->
                  _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NATLIT _v ->
                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | MATCH ->
                  _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LPAR ->
                  _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IF0 ->
                  _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FUN ->
                  _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | EMPTY ->
                  _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_055 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LPAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_42 t in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState055
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState055
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | _ ->
          _eRR ()
  
  and _menhir_run_053 : type  ttv_stack. ((((((ttv_stack, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_THEN, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_ELSE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState053
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState053
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | END ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_ELSE (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, t1) = _menhir_stack in
          let MenhirCell1_THEN (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _, t) = _menhir_stack in
          let MenhirCell1_IF0 (_menhir_stack, _menhir_s) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_38 t t1 t2 in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState053
      | _ ->
          _eRR ()
  
  and _menhir_run_051 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_IF0, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_THEN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | NATLIT _v_0 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState051
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | IDENT _v_1 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState051
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | ELSE ->
          let _menhir_stack = MenhirCell1_ELSE (_menhir_stack, MenhirState051) in
          let _menhir_s = MenhirState052 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
      | _ ->
          _eRR ()
  
  and _menhir_run_049 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_IF0 as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | THEN ->
          let _menhir_stack = MenhirCell1_THEN (_menhir_stack, MenhirState049) in
          let _menhir_s = MenhirState050 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NODE ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NIL ->
              _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NATLIT _v ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAR ->
              _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IF0 ->
              _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EMPTY ->
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | PLUS ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | NATLIT _v_2 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState049
      | MINUS ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | IDENT _v_3 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState049
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | CONS ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState049
      | _ ->
          _eRR ()
  
  and _menhir_run_048 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_CONS as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | BAR | COMMA | DASH | DEFINITION | ELSE | EMPTY | END | EOF | EQ | FUN | IDENT _ | IF0 | LPAR | MATCH | NATLIT _ | NIL | NODE | PRINT | RPAR | SEP | THEN | THEOREM | WITH ->
          let MenhirCell1_CONS (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _menhir_s, t1) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_29 t1 t2 in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_045 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_MINUS as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | BAR | COMMA | CONS | DASH | DEFINITION | ELSE | EMPTY | END | EOF | EQ | FUN | IDENT _ | IF0 | LPAR | MATCH | MINUS | NATLIT _ | NIL | NODE | PLUS | PRINT | RPAR | SEP | THEN | THEOREM | WITH ->
          let MenhirCell1_MINUS (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _menhir_s, t1) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_36 t1 t2 in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_043 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_PLUS as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState043
      | BAR | COMMA | CONS | DASH | DEFINITION | ELSE | EMPTY | END | EOF | EQ | FUN | IDENT _ | IF0 | LPAR | MATCH | MINUS | NATLIT _ | NIL | NODE | PLUS | PRINT | RPAR | SEP | THEN | THEOREM | WITH ->
          let MenhirCell1_PLUS (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_tm (_menhir_stack, _menhir_s, t1) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_35 t1 t2 in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_041 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_tm -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_tm (_menhir_stack, _menhir_s, t1) = _menhir_stack in
      let t2 = _v in
      let _v = _menhir_action_39 t1 t2 in
      _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_040 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_tm, _menhir_box_program) _menhir_cell1_TIMES -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_TIMES (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_tm (_menhir_stack, _menhir_s, t1) = _menhir_stack in
      let t2 = _v in
      let _v = _menhir_action_37 t1 t2 in
      _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_038 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_IDENT, _menhir_box_program) _menhir_cell1_ty as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | PLUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | NODE ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | NIL ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | NATLIT _v_0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState038
      | MINUS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | MATCH ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | LPAR ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | IF0 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState038
      | FUN ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | END ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_ty (_menhir_stack, _, ty) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, x) = _menhir_stack in
          let MenhirCell1_FUN (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_40 t ty x in
          _menhir_goto_tm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | EMPTY ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | CONS ->
          let _menhir_stack = MenhirCell1_tm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState038
      | _ ->
          _eRR ()
  
  and _menhir_run_034 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TYTREE ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYLST ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYARROW ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ARROW ->
              let _menhir_s = MenhirState036 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NODE ->
                  _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NIL ->
                  _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NATLIT _v ->
                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | MATCH ->
                  _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LPAR ->
                  _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IF0 ->
                  _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FUN ->
                  _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | EMPTY ->
                  _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_018 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LPAR _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TYTREE ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYLST ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYARROW ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, i) = _menhir_stack in
          let MenhirCell1_LPAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_01 i t in
          (match (_tok : MenhirBasics.token) with
          | LPAR ->
              let _menhir_stack = MenhirCell1_arg (_menhir_stack, _menhir_s, _v) in
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState157
          | COLON ->
              let x = _v in
              let _v = _menhir_action_11 x in
              _menhir_goto_nonempty_list_arg_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_arg_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState167 ->
          _menhir_run_168 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState157 ->
          _menhir_run_158 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState006 ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_168 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_DEFINITION _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_nonempty_list_arg_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState169 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TYNAT ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_158 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_arg -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_arg (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_12 x xs in
      _menhir_goto_nonempty_list_arg_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_020 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_THEOREM _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_nonempty_list_arg_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState021 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NIL ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NATLIT _v ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAR ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IF0 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EMPTY ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_016 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_ty as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TYTREE ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYLST ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYARROW ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ | RPAR ->
          let MenhirCell1_ty (_menhir_stack, _menhir_s, t1) = _menhir_stack in
          let t2 = _v in
          let _v = _menhir_action_44 t1 t2 in
          _menhir_goto_ty _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_012 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LPAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TYTREE ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYLST ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | TYARROW ->
          let _menhir_stack = MenhirCell1_ty (_menhir_stack, _menhir_s, _v) in
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_47 t in
          _menhir_goto_ty _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState000 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | THEOREM ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PRINT ->
          _menhir_run_159 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EOF ->
          _menhir_run_162 _menhir_stack _menhir_s
      | DEFINITION ->
          _menhir_run_163 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let program =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_program v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
