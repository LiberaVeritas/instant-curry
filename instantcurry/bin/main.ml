open Icparser
open Instantcurry
open Core

module L = MenhirLib.LexerUtil

(* remove grade and export to run in cli *)
(*let grade text =
  let lexbuf = Lexing.from_string text in
  let ptree = ParserUtil.parse_loop lexbuf text in
  let prog = Lifting.lift_program ptree in
  let _ = Typechecking.typecheck_prog prog in
  ()

let export () = (Js_of_ocaml.Js.export "grade" grade)*)

let add_common ptree =
  (* load common theorems if exists *)
  match Sys_unix.file_exists "./common.ic" with
  | `Yes ->
    let t, buf = L.read "./common.ic" in
    let p_common =
      try
        ParserUtil.parse_loop buf t
      with ParserUtil.SyntaxError s ->
        printf "\n%s\n" s;
      raise @@ ParserUtil.SyntaxError "common.ic";
    in
    printf "Imported common.ic\n";
    p_common @ ptree
  | `No | `Unknown ->
  ptree
  
let () =
  let args = Sys.get_argv () in 
  let () = Stdio.printf "%s\n" args.(1) in
  if (String.equal args.(1) "export") then () (*export ()*)
  else
  
  let infile = args.(1) in
  let text, lexbuf = L.read infile in
  let ptree = 
  try
    ParserUtil.parse_loop lexbuf text
  with ParserUtil.SyntaxError s ->
    printf "\n%s\n" s;
    raise @@ ParserUtil.SyntaxError "";
  in
  let ptree = add_common ptree in
  printf "Parsing succeeded\n";
  let prog = Lifting.lift_program ptree in
  printf "Lifting succeeded\n";
  let _ = Typechecking.typecheck_prog prog in
  printf "Typechecking succeeded\n";
  let _ = Proof.check_prog prog in
  printf "Proof checking succeeded\n";
  ()


