open Synint
open Core
open Lifting


module P = Icparser.Parsed_ast

type log = string list

let add s (l : log) = s :: l

let bind f m =
  let (a, log) = m in
  let (b, log') = f a in
  (b, log' @ log)

let map f m =
  let (a, log) = m in
  (f a, log)

let (let+) = map


let (let*) = bind

let lift_program (p : P.program) (log : log) : (Synint.program * log) =
  let log = log |> add ("Lifting program:\n" ^ P.show_prog p ^ "\n") in
  let res = lift_program p in
  let log = log |> add ("Lifted program:\n" ^ show_prog res ^ "\n") in
  (res, log)


