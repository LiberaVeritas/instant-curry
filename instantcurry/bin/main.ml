open Icparser
open Core
open Instantcurry
open Stdio

(*let stdout = Out_channel.stdout*)
(*let print s = output_hum stdout s; printf "\n"*)

(*open Instantcurry*)

(* let example_append_statement : Synint.stmt =
    let open Synint in {
      quantifiers = ["l3"; "l2"; "l1"];
      claim = {  app (app l1 l2) l3 = app l1 (app l2 l3) 
          lhs = Ref "app" ++ (Ref "app" ++ MVar ("l1") ++ MVar "l2") ++ MVar ("l3");
          rhs = Ref "app" ++ MVar "l1" ++ (Ref "app" ++ MVar "l2" ++ MVar "l3");
      };
    } *)

(* let apply_tm () =
    let open Synint in
    unify
        (App (Fun ("x", Ty_Nat, BVar "x"), Nat 3))
        (Nat 3)
        ByDefinition*)

	
(*let _ =
let ast =
let x = (Lexer.read_token) in
let y = (Lexing.from_string @@ read_line ()) in
        try Parser.program (x) (y) with
        | Parser.Error -> failwith "Does not parse"
    in*)
    (* some stupid stuff to ensure that definitions above are used to avoid errors: *)
    (*Format.fprintf Format.std_formatter "Parsed %d theorems and here is a number: %d"
        (List.length ast)
        (List.length example_append_statement.quantifiers) *)


(*let usage_message = "Usage: instantcurry <infile> <outfile>"*)
type p = (string * Typechecking.ty_scheme) list [@@deriving sexp]
type prog = Synint.stmt list [@@deriving sexp]

let () =
    let args = Sys.get_argv () in 
    let infile = args.(1) in
    
    (*let outfile = args.(1)  in *)

    let ic = In_channel.create infile in
    (*let oc = Out_channel.create outfile in *)
    let lextok = (Lexer.read_token) in
    let lexbuf = (Lexing.from_channel ic) in
    let ptree = try Parser.program lextok lexbuf with
        | Parser.Error -> failwith (Int.to_string lexbuf.lex_curr_p.pos_lnum)
    in
    printf "parsing succeeded\n";
    let prog = Lifting.lift_program ptree in
    printf "lifting succeeded\n";
    (*let () = List.iter (Out_channel.printf "%s\n") sexp_of_program ptree in*)
    (*let buf = Buffer.create 2048 in
    Buffer.output_buffer oc buf;*)
    
    (* print_prog p oc *)
    (*let _ = Eval.exec_prog prog in *)
    let _ = Typechecking.typecheck_prog prog in
    printf "typecheck succeeded\n";
    (*let () = Theorem.check prog in*)
    let _ = Proof.check_prog prog in
    In_channel.close ic
    (*print (sexp_of_p p);*)
    (*Sexp.pp_hum Format.std_formatter (sexp_of_program ptree);*)
    (*Translate.print_prog ptree oc *)

