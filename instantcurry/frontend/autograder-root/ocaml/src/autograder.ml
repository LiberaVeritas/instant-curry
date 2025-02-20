open Js_of_ocaml

exception Error of string
exception SyntaxError of int * string
exception LexerError of int * string

let evaluate = function
  | _ -> raise (Error "TO DO")

let grade (expression: string): string =
  try
    let lexbuf = Lexing.from_string expression in
    let ast =
      try
        Parser.program Lexer.read_token lexbuf
      with
      | Lexer.SyntaxError msg ->
          let line = lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum in
          raise (LexerError (line, msg))
      | Parser.Error ->
          let line = lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum in
          raise (SyntaxError (line, Lexing.lexeme lexbuf))
    in
    let results =
      List.map evaluate ast
      |> String.concat "\n"
    in
    Printf.sprintf {|{ "result": "%s" }|} results  
  with
  | LexerError (line, msg) ->
      Printf.sprintf {|{ "error": "Lexer error at line %d: %s", "line": %d }|} line msg line
  | SyntaxError (line, token) ->
      Printf.sprintf {|{ "error": "Syntax error at line %d near: %s", "line": %d }|} line token line
  | Failure msg -> Printf.sprintf {|{ "error": "%s" }|} msg  

let () = Js.export "grade" grade