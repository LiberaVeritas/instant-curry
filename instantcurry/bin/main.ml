open Icparser
open Instantcurry
open Core

module L = MenhirLib.LexerUtil

(* remove grade and export to run in cli *)
let grade text =
  let lexbuf = Lexing.from_string text in
  let ptree = ParserUtil.parse_loop lexbuf text in
  let prog = Lifting.lift_program ptree in
  let _ = Typechecking.typecheck_prog prog in
  ()

let export () = (Js_of_ocaml.Js.export "grade" grade)
  
let () =
  let args = Sys.get_argv () in 
  let () = Stdio.printf "%s" args.(1) in
  if (String.equal args.(1) "export") then export ()
  else
  let infile = args.(1) in
  let text, lexbuf = L.read infile in
  let ptree = ParserUtil.parse_loop lexbuf text in
  let prog = Lifting.lift_program ptree in
  let _ = Typechecking.typecheck_prog prog in
  ()


