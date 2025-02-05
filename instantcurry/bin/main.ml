open Icparser
open Instantcurry

(* let example_append_statement : Synint.stmt =
    let open Synint in {
      quantifiers = ["l3"; "l2"; "l1"];
      claim = { (* app (app l1 l2) l3 = app l1 (app l2 l3) *)
          lhs = Ref "app" ++ (Ref "app" ++ MVar ("l1") ++ MVar "l2") ++ MVar ("l3");
          rhs = Ref "app" ++ MVar "l1" ++ (Ref "app" ++ MVar "l2" ++ MVar "l3");
      };
    } *)

(* let apply_tm () =
    let open Synint in
    unify
        (App (Fun ("x", Ty_Nat, BVar "x"), Nat 3))
        (Nat 3)
        ByDefinition

	
let _ =
let ast =
let x = (Lexer.read_token) in
let y = (Lexing.from_string @@ read_line ()) in
        try Parser.program (x) (y) with
        | Parser.Error -> failwith "Does not parse"
    in
    (* some stupid stuff to ensure that definitions above are used to avoid errors: *)
    Format.fprintf Format.std_formatter "Parsed %d theorems and here is a number: %d"
        (List.length ast)
        (List.length example_append_statement.quantifiers) *)

let usage_message = "Usage: instantcurry <infile> <outfile>"

let () =
    let infile = try Sys.argv.(1) with
        | Invalid_argument _ -> failwith usage_message
    in
    let outfile = try Sys.argv.(2) with
    | Invalid_argument _ -> failwith usage_message
in
    let ic = open_in infile in
    let oc = open_out outfile in
    let x = (Lexer.read_token) in
    let y = (Lexing.from_channel ic) in
    let ptree = try Parser.program (x) (y) with
        | Parser.Error -> failwith (string_of_int y.lex_curr_p.pos_lnum)
    in
    let tcheck = Typechecking.typecheck_prog prog in
    let ev = Eval.exec_prog prog in ()
    (* Translate.print_prog ptree oc *)
