open Core
open Lexing
(*open Yojson.Basic*)

exception SyntaxError of string

(* https://gitlab.inria.fr/fpottier/menhir/-/tree/master/demos/calc-syntax-errors *)
module E = MenhirLib.ErrorReports
module I = Parser.MenhirInterpreter
module L = MenhirLib.LexerUtil


(* build a json for syntax error messages 
line is line number in source
start and stop are the markers for the range of the error token.
  They represent number of characters within the line.
  Note: the range can be empty (start = stop)
message is the error message (including Hints if any)
  this is <YOUR SYNTAX ERROR MESSAGE HERE> when a specific messsage 
  doesn't exist
state is the internal parser state that led to the error.
  useful to report to help find where and how the error happened.
*)
let jsonify line start stop msg advice state : string =
  Yojson.Basic.pretty_to_string @@ 
  `Assoc 
  [
    ("type", `String "Syntax Error");
    ("line", `Int line);
    ("start", `Int start);
    ("stop", `Int stop);
    ("message", `String msg);
    ("state", `Int state);
    ("advice", `String advice);
  ]

let succeed v =
  (* The parser has succeeded and produced a semantic value. Print it. *)
  Printf.printf "Parsing succeeded\n";
  v
  
(* [env checkpoint] extracts a parser environment out of a checkpoint,
   which must be of the form [HandlingError env]. *)
let env checkpoint =
  match checkpoint with
  | I.HandlingError env ->
      env
  | _ ->
      assert false

(* [state checkpoint] extracts the number of the current state out of a
   checkpoint. *)
let state checkpoint : int =
  match I.top (env checkpoint) with
  | Some (I.Element (s, _, _, _)) ->
      I.number s
  | None ->
    (* Hmm... The parser is in its initial state. The incremental API
         currently lacks a way of finding out the number of the initial
         state. It is usually 0, so we return 0. This is unsatisfactory
         and should be fixed in the future. *)
      0

(* [show text (pos1, pos2)] displays a range of the input text [text]
   delimited by the positions [pos1] and [pos2]. *)
let show text positions =
  E.extract text positions
  |> E.sanitize
  |> E.compress
  |> E.shorten 20 (* max width 43 *)

(* [get text checkpoint i] extracts and shows the range of the input text that
   corresponds to the [i]-th stack cell. The top stack cell is numbered zero. *)

let get text checkpoint i =
  if i = 0 then show text (I.positions (env checkpoint)) else 
  match I.get (i - 1) (env checkpoint) with
  | Some (I.Element (_, _, pos1, pos2)) ->
      show text (pos1, pos2)
  | None ->
      (* The index is out of range. This should not happen if [$i]
         keywords are correctly inside the syntax error message
         database. The integer [i] should always be a valid offset
         into the known suffix of the stack. *)
      "???"

(* gets the line in the text corresponding to the line number in positions *)
let get_line text (pos1, _) =
  let start = pos1.pos_bol in
  let last = String.index_from_exn text start '\n' in
  String.sub ~pos:start ~len:(last - start) text

let line_num (pos1,_) =
  pos1.pos_lnum

(* upon failure to parser *)
let fail text buffer (checkpoint : _ I.checkpoint) =
  (* Indicate where in the input file the error occurred. *)
  let positions = E.last buffer in
  let location = L.range positions in
  (* Show the tokens just before and just after the error. *)
  let indication = "> " ^ (get_line text positions) ^ "\n" in
  let indication = indication ^ ((E.show (show text) buffer) ^ "\n") in
  let indication = indication ^ Int.to_string (state checkpoint) ^ "\n" in
  (* Fetch an error message from the .messages database. *)
  let message = Messages.message (state checkpoint) in
  (* Expand away the $i keywords that might appear in the message. *)
  let message = E.expand (get text checkpoint) message in
  
  (* Split message by HINT: token *)
  let res = String.substr_replace_all message ~pattern:"\nHint: " ~with_:"`" in
  let res = String.split res ~on:'`' in
  let (message, advice) = 
    match res with
    | [] -> ("", "")
    | x::[] -> (x, "")
    | x::y::_ -> (x, y)
  in
  
  let (pos1, pos2) = positions in
  let start = (pos1.pos_cnum - pos1.pos_bol) in
  let stop = (pos2.pos_cnum - pos2.pos_bol) in
  (* Show these three components. *)
  let () = Stdio.printf "%s%s%s%!" location indication message in
  raise (SyntaxError (jsonify (line_num positions) start stop message advice (state checkpoint)))
  (* required to typecheck -> Parsed_ast.program *)
  
  
  

(* feed the parser tokens until it completes or fails *)
let parse_loop lexbuf text =
  let supplier = I.lexer_lexbuf_to_supplier Lexer.read_token lexbuf in
  let buffer, supplier = E.wrap_supplier supplier in
  let checkpoint = Parser.Incremental.program lexbuf.lex_curr_p in
  I.loop_handle succeed (fail text buffer) supplier checkpoint

