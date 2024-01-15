%{
    [@@@coverage exclude_file]
    open Parsed_ast
%}

%token EOF

(* instant-curry keywords *)
%token THEOREM
%token PROOF
%token BY
%token INDUCTION
%token ON
%token CASE
%token WTS
%token <string> IH
%token LHS
%token RHS
%token QED

(* nats and idents *)
%token <int> NATLIT
%token <string> IDENT

(* symbols *)
%token LPAR
%token RPAR
%token LBRA
%token RBRA
%token EQ
%token CONS
%token NIL
%token PLUS
%token SEP


(* precedence/associativity *)
%left EQ
%right CONS
%left PLUS
%nonassoc NIL NATLIT IDENT LPAR
%nonassoc APP

%start program

%type <Parsed_ast.program> program
%type <Parsed_ast.stmt> stmt
%type <Parsed_ast.proof> proof
%type <Parsed_ast.case> case
%type <Parsed_ast.side> side
%type <Parsed_ast.tm> tm

%%

program:
| stmt program                          { $1 :: $2 }
| EOF                                   { [] }

stmt:
| THEOREM 
  LPAR v = IDENT RPAR SEP 
  t = tm SEP 
  p = proof                             { Theorem (v, t, p) }

proof:
| PROOF BY INDUCTION ON i = IDENT SEP
  cs = cases QED SEP                    { (i, cs) }

cases:
| case cases                            { $1 :: $2 }
| case                                  { [$1] }

case:
| CASE
  LBRA i = IDENT EQ t = tm RBRA SEP
  ihs = ihs?
  wts = wts
  LHS lhs = side
  RHS rhs = side                        { (i, t, ihs, wts, lhs, rhs) }

wts:
| WTS t = tm SEP                        { t }

ihs:
| ih ihs                                { $1 :: $2 }
| ih                                    { [$1] }

ih:
| id = IH t = tm SEP                    { (id, t) }

side:
| step side                             { $1 :: $2 }
| step                                  { [$1] }

step:
| EQ t = tm BY i = IDENT SEP            { (t, i) }

tm:
| NIL                                   { Nil }
| t1 = tm CONS t2 = tm                  { Cons (t1, t2) }
| NATLIT                                { Nat $1 }
| t1 = tm PLUS t2 = tm                  { Plus (t1, t2) }
| t1 = tm EQ t2 = tm                    { Eq (t1, t2) }
| IDENT                                 { Var $1 }
| t1 = tm t2 = tm           %prec APP   { App (t1, t2) }
| LPAR t = tm RPAR                      { t }
