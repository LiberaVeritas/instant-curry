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
        try Parser.program (Lexer.read_token) (Lexing.from_string @@ read_line ()) with
        | Parser.Error -> failwith "Does not parse"
    in
    (* some stupid stuff to ensure that definitions above are used to avoid errors: *)
    Format.fprintf Format.std_formatter "Parsed %d theorems and here is a number: %d"
        (List.length ast)
        (List.length example_append_statement.quantifiers) *)

let usage_message = "Usage: instantcurry <filename>"

let () =
    let filename = try Sys.argv.(1) with
        | Invalid_argument _ -> failwith usage_message
    in
    let channel = open_in filename in
    let ptree = try Parser.program (Lexer.read_token) (Lexing.from_channel channel) with
        | Parser.Error -> failwith "Does not parse"
    in
    let prog = Lifting.lift_program ptree in
    let _ = Typechecking.typecheck_prog prog in
    let _ = Eval.exec_prog prog in ()
