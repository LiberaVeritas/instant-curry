{
    open Lexing
    open Parser

    exception SyntaxError of string

    let next_line lexbuf =
        let pos = lexbuf.lex_curr_p in
        lexbuf.lex_curr_p <-
            {
                pos with pos_bol = lexbuf.lex_curr_pos;
                         pos_lnum = pos.pos_lnum + 1
            }
}

let ws = [ ' ' '\t']+
let newline = '\n' | "\r\n"
let digit = [ '0'-'9' ]
let nat = digit+
let alpha = [ 'a'-'z' 'A'-'Z' ]
let ident = [ 'a'-'z' ] ( alpha | digit | '_' | '\'' )*
let ih = "IH_" (digit as d)

rule read_token = parse
| ws                        { read_token lexbuf }
| newline                   { next_line lexbuf ; read_token lexbuf }
| eof                       { EOF }

(* proof language keywords *)
| "DEFINITION"              { DEFINITION }
| "PRINT"                   { PRINT }
| "THEOREM"                 { THEOREM }
| "PROOF"                   { PROOF }
| "BY"                      { BY }
| "INDUCTION"               { INDUCTION }
| "ON"                      { ON }
| "FORALL"                  { FORALL }
| "CASE"                    { CASE }
| "WTS"                     { WTS }
| "IH" (nat as n)           { IH (int_of_string n) }
| "IH"                      { IH 0 }
| "LHS"                     { LHS }
| "RHS"                     { RHS }
| "QED"                     { QED }
| "AXIOM"                   { AXIOM }

(* term language keywords *)
| "let"                     { LET }
| "rec"                     { REC }
| "match"                   { MATCH }
| "with"                    { WITH }
| "if0"                     { IF0 }
| "then"                    { THEN }
| "else"                    { ELSE }
| "fun"                     { FUN }
| "end"                     { END }
| "Empty"                   { EMPTY }
| "Node"                    { NODE }

(* types *)
| "nat"                     { TYNAT }
| "list"                    { TYLST }
| "tree"                    { TYTREE }
| "->"                      { TYARROW }

(* nats and idents *)
| nat                       { NATLIT (int_of_string (Lexing.lexeme lexbuf)) }
| ident                     { IDENT (Lexing.lexeme lexbuf) }

(* symbols *)
| "("                       { LPAR }
| ")"                       { RPAR }
| "="                       { EQ }
| "::"                      { CONS }
| "[]"                      { NIL }
| "+"                       { PLUS }
| "-"                       { MINUS }
| "*"                       { TIMES }
| "."                       { SEP }
| "=>"                      { ARROW }
| "|"                       { BAR }
| ":"                       { COLON }
| ","                       { COMMA }
| "--"                      { DASH }

| _                         { raise (SyntaxError ("Lexer Error: Illegal character: " ^ Lexing.lexeme lexbuf)) }

