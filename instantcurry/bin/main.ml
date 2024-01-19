open Icparser
open Instantcurry

let example_append_statement : Synint.stmt =
    let open Synint in {
      quantifiers = ["l3"; "l2"; "l1"];
      claim = { (* app (app l1 l2) l3 = app l1 (app l2 l3) *)
          lhs = Ref "app" ++ (Ref "app" ++ MVar ("l1", 2) ++ MVar ("l2", 1)) ++ MVar ("l3", 0);
          rhs = Ref "app" ++ MVar ("l1", 2) ++ (Ref "app" ++ MVar ("l2", 1) ++ MVar ("l3", 0));
      };
    }


let _ =
    let ast =
        try Parser.program (Lexer.read_token) (Lexing.from_string @@ read_line ()) with
        | Parser.Error -> failwith "Does not parse"
    in
    (* some stupid stuff to ensure that definitions above are used to avoid errors: *)
    Format.fprintf Format.std_formatter "Parsed %d theorems and here is a number: %d"
        (List.length ast)
        (List.length example_append_statement.quantifiers)
