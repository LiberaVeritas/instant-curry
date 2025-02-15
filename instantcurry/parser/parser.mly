%{
    [@@@coverage exclude_file]
    open Parsed_ast
%}

(* TODO make type annotations optional *)

%token EOF

(* proof language keywords *)
%token DEFINITION
%token PRINT
%token THEOREM
%token GENERALIZE
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
%token LEMMA

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
%token EMPTY
%token NODE

(* types *)
%token TYNAT
%token TYARROW
%token TYLST
%token TYTREE
%token <string> TYVAR

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
%token DASH
%token COMMA

(* precedence/associativity *)
%right TYARROW
%nonassoc TYLST
%nonassoc TYTREE

// %nonassoc NIL EMPTY NODE NATLIT IDENT LPAR MATCH IF0 FUN
// %right CONS
// %left PLUS MINUS
// %left TIMES
// %nonassoc APP (* TODO: this precedence is not respected? *)

%start program

%type <Parsed_ast.program> program

%%

program:
| stmt program                          { $1 :: $2 }
| EOF                                   { [] }

stmt:
| THEOREM LPAR v = IDENT RPAR SEP 
  FORALL ps = arg+ COLON 
  c = eqn COLON t = ty SEP 
  p = proof                             { Theorem (v, ps, (c, t), p) }
| DEFINITION SEP LET REC 
  f = IDENT ps = arg+ COLON ty = ty
  EQ tm = tm                            { Definition (f, true, ps, ty, tm) }
| DEFINITION SEP LET REC 
  f = IDENT ps = arg+
  EQ tm = tm                            { Definition (f, true, ps, fresh (), tm) }
| DEFINITION SEP LET 
  f = IDENT ps = arg+ COLON ty = ty
  EQ tm = tm                            { Definition (f, false, ps, ty, tm) }
| DEFINITION SEP LET 
  f = IDENT ps = arg+ 
  EQ tm = tm                            { Definition (f, false, ps, fresh (), tm) }
| PRINT SEP tm = tm                     { Print tm }

arg:
| LPAR i = IDENT COLON ty = ty RPAR     { (i, ty) }
| i = IDENT                             { (i, fresh ()) }
| LPAR i = IDENT RPAR                   { (i, fresh ()) }


proof:
| PROOF SEP 
  BY INDUCTION ON i = IDENT 
  gs = generalize? SEP
  cs = case* QED SEP                    { Proof (i, gs, cs) }
| AXIOM SEP                             { Axiom }

generalize:
| COMMA GENERALIZE gs = IDENT+          { gs }

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
| EQ t = tm DASH BY LEMMA i = IDENT SEP	{ (t, "LEMMA " ^ i) }
| EQ t = tm DASH BY i = IDENT SEP       { (t, i) }
| EQ t = tm DASH BY ih = IH SEP         { (t, "IH" ^ string_of_int ih) }

pattern:
| NIL                                   { Pat_nil }
| x = IDENT CONS xs = IDENT             { Pat_cons (x, xs) }
| EMPTY                                 { Pat_empty }
| NODE LPAR l = IDENT COMMA
            x = IDENT COMMA
            r = IDENT RPAR              { Pat_node (l, x, r) }

eqn:
| t1 = tm EQ t2 = tm                    { (t1, t2) }

tm:
| t1 = addsub_tm CONS t2 = tm           { Cons (t1, t2) } 
| t = addsub_tm                         { t }

addsub_tm:
| t1 = addsub_tm PLUS t2 = mul_tm       { Plus (t1, t2) }
| t1 = addsub_tm MINUS t2 = mul_tm      { Minus (t1, t2) }
| t = mul_tm                            { t }

mul_tm:
| t1 = mul_tm TIMES t2 = key_tm         { Times (t1, t2) }
| t = key_tm                            { t }

key_tm:
| NODE LPAR l = tm COMMA
            x = tm COMMA
            r = tm RPAR                 { Node (l, x, r) }
| MATCH l = tm WITH 
  BAR? NIL ARROW t1 = tm
  BAR x = IDENT CONS xs = IDENT ARROW 
  t2 = tm END                           { ListCase (l, t1, x, xs, t2) }
| MATCH t = tm WITH 
  BAR? EMPTY ARROW t1 = tm
  BAR NODE LPAR l = IDENT COMMA 
                x = IDENT COMMA
                r = IDENT RPAR
  ARROW t2 = tm END                     { TreeCase (t, t1, l, x, r, t2) }
| IF0 t = tm THEN t1 = tm 
  ELSE t2 = tm END                      { If0 (t, t1, t2) }
| FUN LPAR x = IDENT COLON ty = ty RPAR
  ARROW t = tm END                      { Fun (x, ty, t) }
| t = app_tm                            { t }

app_tm:
| t1 = app_tm t2 = atom_tm              { App (t1, t2) }
| t = atom_tm                           { t }

atom_tm:
| NIL                                   { Nil }
| EMPTY                                 { Empty }
| n = NATLIT                            { Nat n }
| IDENT                                 { Var $1 }
| LPAR t = tm RPAR                      { t }

(*
tm:
| NIL                                   { Nil }
| t1 = tm CONS t2 = tm                  { Cons (t1, t2) }
| EMPTY                                 { Empty }
| NODE LPAR l = tm COMMA
            x = tm COMMA
            r = tm RPAR                 { Node (l, x, r) }
| MATCH l = tm WITH 
  BAR? NIL ARROW t1 = tm
  BAR x = IDENT CONS xs = IDENT ARROW 
  t2 = tm END                           { ListCase (l, t1, x, xs, t2) }
| MATCH t = tm WITH 
  BAR? EMPTY ARROW t1 = tm
  BAR NODE LPAR l = IDENT COMMA 
                x = IDENT COMMA
                r = IDENT RPAR
  ARROW t2 = tm END                     { TreeCase (t, t1, l, x, r, t2) }
| NATLIT                                { Nat $1 }
| t1 = tm PLUS t2 = tm                  { Plus (t1, t2) }
| t1 = tm MINUS t2 = tm                 { Minus (t1, t2) }
| t1 = tm TIMES t2 = tm                 { Times (t1, t2) }
| IF0 t = tm THEN t1 = tm 
  ELSE t2 = tm END                      { If0 (t, t1, t2) }
| FUN LPAR x = IDENT COLON ty = ty RPAR
  ARROW t = tm END                      { Fun (x, ty, t) }
| IDENT                                 { Var $1 }
| LPAR t = tm RPAR                      { t }
| t1 = tm t2 = tm     %prec APP         { App (t1, t2) }
*)


ty:
| TYNAT                                 { Ty_Nat }
| t1 = ty TYARROW t2 = ty               { Ty_Arrow (t1, t2) }
| t = ty TYLST                          { Ty_List t }
| t = ty TYTREE                         { Ty_Tree t }
| t = TYVAR                             { Ty_Var t }
| LPAR t = ty RPAR                      { t }


