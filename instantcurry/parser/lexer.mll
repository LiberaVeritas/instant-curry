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
let ih = "IH" (digit as d)
let comment_start = "(*"
let comment_end = "*)"
let comment_line = "#"

rule comment = parse
| comment_end               { read_token lexbuf }
| _                         { comment lexbuf }
| eof                       { EOF }

and comment_line = parse
| newline                   { read_token lexbuf }
| _                         { comment_line lexbuf }
| eof                       { EOF }

and read_token = parse
| ws                        { read_token lexbuf }
| comment_start             { comment lexbuf }
| comment_line              { comment_line lexbuf }
| newline                   { next_line lexbuf ; read_token lexbuf }
| eof                       { EOF }




(* proof language keywords *)
| "DEFINITION"              { DEFINITION }
| "CONST"                   { CONST }
| "PRINT"                   { PRINT }
| "THEOREM"                 { THEOREM }
| "GENERALIZE"              { GENERALIZE }
| "PROOF"                   { PROOF }
| "BY"                      { BY }
| "INDUCTION"               { INDUCTION }
| "ON"                      { ON }
| "FORALL"                  { FORALL }
| "CASE"                    { CASE }
| "WTS"                     { WTS }
| "IH" (nat as n)           { IH (int_of_string n) }
| "LHS"                     { LHS }
| "RHS"                     { RHS }
| "QED"                     { QED }
| "AXIOM"                   { AXIOM }
(*| "LEMMA"		                { LEMMA }*)

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
| "defn"                    { DEFN }
| "of"                      { OF }
(*| "Empty"                   { EMPTY }*)
(*| "Node"                    { NODE }*)

(* types *)
| "nat"                     { TYNAT }
| "list"                    { TYLST }
(*| "tree"                    { TYTREE }*)
| "->"                      { TYARROW }
| '\'' ([ 'a'-'z' ]+ as v)  { TYVAR (String.uppercase_ascii v) }

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

