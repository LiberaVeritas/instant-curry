open Icparser
 
let _ = try Parser.program (Lexer.read_token) (Lexing.from_string @@ read_line ()) with
| Parser.Error -> print_endline "Does not parse" ; []
