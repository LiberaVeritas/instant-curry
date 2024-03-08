%{
    [@@@coverage exclude_file]
    open Parsed_ast
%}

%token EOF

(* proof language keywords *)
%token DEFINITION
%token PRINT
%token THEOREM
%token PROOF
%token BY
%token INDUCTION
%token ON
%token FORALL
%token CASE
%token WTS
%token <int> IH
%token LHS
%token RHS
%token QED
%token AXIOM

(* term language keywords *)
%token LET
%token REC
%token MATCH
%token WITH
%token IF0
%token THEN
%token ELSE
%token FUN
%token END

(* types *)
%token TYNAT
%token TYARROW
%token TYLST

(* nats and idents *)
%token <int> NATLIT
%token <string> IDENT

(* symbols *)
%token LPAR
%token RPAR
%token EQ
%token CONS
%token NIL
%token PLUS
%token MINUS
%token TIMES
%token SEP
%token ARROW
%token BAR
%token COLON

(* precedence/associativity *)
%right TYARROW
%nonassoc TYLST

%nonassoc NIL NATLIT IDENT LPAR MATCH IF0 FUN
%right CONS
%left PLUS MINUS
%left TIMES
%nonassoc APP (* TODO: this precedence is not respected? *)

%start program

%type <Parsed_ast.program> program

%%

program:
| stmt program                          { $1 :: $2 }
| EOF                                   { [] }

stmt:
| THEOREM LPAR v = IDENT RPAR SEP 
  FORALL ps = arg+ COLON 
  c = eqn SEP p = proof                 { Theorem (v, ps, c, p) }
| DEFINITION SEP LET REC 
  f = IDENT ps = arg+ COLON ty = ty
  EQ t = tm                             { Definition (f, true, ps, ty, t) }
| PRINT SEP t = tm                      { Print t }

arg:
| LPAR i = IDENT COLON t = ty RPAR      { (i, t) }

proof:
| PROOF BY INDUCTION ON i = IDENT SEP
  cs = case* QED SEP                    { Proof (i, cs) }
| AXIOM SEP                             { Axiom }

case:
| CASE
  i = IDENT EQ p = pattern SEP
  ihs = ih*
  WTS COLON wts = eqn SEP
  LHS lhs = side
  RHS rhs = side                        { (i, p, ihs, wts, lhs, rhs) }

ih:
| id = IH COLON e = eqn SEP             { ("IH" ^ string_of_int id, e) }

side:
| EQ t = tm SEP 
  steps = step*                         { (t, steps) }

step:
| EQ t = tm BY i = IDENT SEP            { (t, i) }

pattern:
| NIL                                   { Pat_nil }
| x = IDENT CONS xs = IDENT             { Pat_cons (x, xs) }

eqn:
| t1 = tm EQ t2 = tm                    { (t1, t2) }

tm:
| NIL t = ty                            { Nil t }
| t1 = tm CONS t2 = tm                  { Cons (t1, t2) }
| MATCH l = tm WITH 
  BAR? NIL ARROW t1 = tm
  BAR x = IDENT CONS xs = IDENT ARROW 
  t2 = tm END                           { ListCase (l, t1, x, xs, t2) }
| NATLIT                                { Nat $1 }
| t1 = tm PLUS t2 = tm                  { Plus (t1, t2) }
| t1 = tm MINUS t2 = tm                 { Minus (t1, t2) }
| t1 = tm TIMES t2 = tm                 { Times (t1, t2) }
| IF0 t = tm THEN t1 = tm 
  ELSE t2 = tm END                      { If0 (t, t1, t2) }
| t1 = tm t2 = tm     %prec APP         { App (t1, t2) }
| FUN LPAR x = IDENT COLON ty = ty RPAR
  ARROW t = tm END                      { Fun (x, ty, t) }
| IDENT                                 { Var $1 }
| LPAR t = tm RPAR                      { t }

ty:
| TYNAT                                 { Ty_Nat }
| t1 = ty TYARROW t2 = ty               { Ty_Arrow (t1, t2) }
| t = ty TYLST                          { Ty_List t }
| LPAR t = ty RPAR                      { t }

