
(* This file was auto-generated based on "merged". *)

(* Please note that the function [message] can raise [Not_found]. *)

let message =
  fun s ->
    match s with
    | 48 ->
        "<YOUR SYNTAX ERROR MESSAGE HERE>\n"
    | 46 ->
        "<YOUR SYNTAX ERROR MESSAGE HERE>\n"
    | 41 ->
        "<YOUR SYNTAX ERROR MESSAGE HERE>\n"
    | 37 ->
        "<YOUR SYNTAX ERROR MESSAGE HERE>\n"
    | 193 ->
        "I expected a '.' here, but instead I found '$0'.\n"
    | 145 ->
        "I expected a '=' followed by the exprssion for the rhs here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY justification.\n  RHS = expression.\n      = ...           -- BY justification.\n"
    | 144 ->
        "I expected a 'RHS' to continue the proof here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY justification.\n  RHS = expression.\n      = ...           -- BY justification.\n"
    | 143 ->
        "I expected a '=' followed by the exprssion for the lhs here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 192 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 191 ->
        "I expected a '=' here, but instead I found '$0'.\nHint: Valid const definitions should be stated like this:\n  CONST x = expression.\n"
    | 190 ->
        "I expected a variable name here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  var_name\n"
    | 115 ->
        "I expected more inductive hypotheses here, but instead I found '$0'.\nHint: Valid nductive hypotheses should be stated like this:\n  IH1 : lhs = rhs.\n"
    | 135 ->
        "I expected a '.' here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY defn of function_name.\n      "
    | 134 ->
        "I expected a function name here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  fun_name\n"
    | 132 ->
        "I expected a '.' or a 'of' followed by a function name here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY defn of function_name.\n      or\n      = ...           -- BY defn.   \n"
    | 128 ->
        "I expected a '.' here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 127 ->
        "I expected a justification for the proof step here, but instead I found '$0'.\nHint: Valid proof steps should be written like this:\n  LHS = expression.\n      = ...           -- BY defn of function_name.\n      or\n      = ...           -- BY defn.         \n      or\n      = ...           -- BY IH1.    \n      or\n      = ...           -- BY theorem_name. \n                      "
    | 113 ->
        "I expected a '.' here, but instead I found '$0'.\nHint: Inductive hypotheses should be stated like this:\n  IH1 : lhs = rhs.\n"
    | 112 ->
        "I expected an expression for the lhs of '$2' here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 111 ->
        "I expected a ':' followed by the equation of the inductive hypothesis here, but instead I found '$0'.\nHint: Inductive hypotheses should be stated like this:\n  IH1 : lhs = rhs.\n"
    | 101 ->
        "I expected a list of cases here, but instead I found '$0'.\nHint: Proofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  CASE l = [].\n  ...\n"
    | 97 ->
        "I expected a '.' or more generalized variable names here, but instead I found '$0'. \nHint: Proofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  ...\n  or\n  PROOF.\n  BY INDUCTION ON l, GENERALIZE x y ...\n"
    | 96 ->
        "I expected a list of argument names here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 95 ->
        "I expected a 'GENERALIZE' here, but instead I found '$0'. \nHint: Did you mean put a period instead of a comma?\nProofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  ...\n  or\n  PROOF.\n  BY INDUCTION ON l, GENERALIZE x y ...\n"
    | 94 ->
        "I expected a '.' or a list of generalization variables here, but instead I found '$0'.\nHint: Proofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  ...\n  or\n  PROOF.\n  BY INDUCTION ON l, GENERALIZE x y ...\n"
    | 195 ->
        "I expected a statement here, but instead I found '$0'.\nHint: Valid statememts are one of:\n  DEFINITION.\n  THEOREM ...\n  PRINT ...\n"
    | 188 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 187 ->
        "I expected a '=' here, but instead I found '$0'.\n"
    | 186 ->
        "I expected a type here, but instead, I found '$0'. This looks like an invalid type declaration.\n  Hint: Valid types are:\n    nat\n    'a\n    'a list\n    'a -> 'b\n    (where 'a and 'b are any valid types)\n"
    | 184 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 182 ->
        "I expected a list of arguments here, but instead I found '$0'.\n"
    | 180 ->
        "I expected a '=' or more arguments here, but instead I found '$0'.\n"
    | 178 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 177 ->
        "I expected a '=' here, but instead I found '$0'.\n"
    | 176 ->
        "I expected a type here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 174 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 165 ->
        "I expected an argument name here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 164 ->
        "I expected the name of the function you are defining here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 163 ->
        "I expected a 'rec' or the name of the function here, but instead I found '$0'.\n"
    | 162 ->
        "I expected a 'let' here, but instead I found '$0'.\n"
    | 161 ->
        "I expected a '.' here, but instead I found '$0'.\n"
    | 158 ->
        "I expected a '.' here, but instead I found '$0'.\n"
    | 157 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 154 ->
        "I expected a '.' here, but instead I found '$0'.\n"
    | 151 ->
        "I expected another case or a 'QED.' here, but instead I found '$0'.\n"
    | 149 ->
        "I expected a '.' to end the proof here, but instead I found '$0'.\n"
    | 141 ->
        "I expected an expression, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  RHS = expression.\n      = ...           -- BY justification.\n"
    | 140 ->
        "I expected a 'RHS' to start the other side of the proof, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n  ...\n  RHS = expression.\n      = ...           -- BY justification.\n"
    | 137 ->
        "I expected another step, a 'RHS', or a 'QED.' here, but instead I found '$0'.\n"
    | 130 ->
        "I expected a '.' to end the justification, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 126 ->
        "I expected a 'BY' followed by a justification here, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 125 ->
        "I expected a '--' followed by a justification here, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 124 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value. Proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 123 ->
        "I expected a '=' here, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 122 ->
        "I expected a '.' here, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 121 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value. Proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 120 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 119 ->
        "I expected a 'LHS' to start the proof steps here, but instead I found '$0'.\nHint: Valid proof steps should be written like:\n  LHS = expression.\n      = ...           -- BY justification.\n"
    | 118 ->
        "I expected a '.' here to end the equation to be solved here, but instead I found '$0'.\n"
    | 117 ->
        "I expected an expression of the lhs of the equation to be solved here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 116 ->
        "I expected a ':' followed by the equation to be solved here, but instead I found '$0'.\n"
    | 110 ->
        "I expected a 'WTS' or a list of induction hypotheses here, but instead I found '$0'.\n"
    | 109 ->
        "I expected a '.' here, but instead I found '$0'.\nHint: Valid cases should be written like:\n  CASE l = [].\n  or \n  CASE l = x::xs.\n"
    | 107 ->
        "I expected name to bind to the rest of the list here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 106 ->
        "I expected a '::' here, but instead I found '$0'.\nHint: Valid list patterns should be written like:\n  []\n  or\n  x::xs\n"
    | 104 ->
        "I expected a list pattern here, but instead I found '$0'.\nHint: Valid list patterns should be written like:\n  []\n  or\n  x::xs\n"
    | 103 ->
        "I expected a '=' here, but instead I found '$0'.\nHint: Valid cases should be written like:\n  CASE l = [].\n  or \n  CASE l = x::xs.\n"
    | 102 ->
        "I expected the name of the induction variable here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 93 ->
        "I expected the name of the induction variable here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 92 ->
        "I expected a 'BY INDUCTION ON l' here, but instead I found '$0'.\nHint: Proofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  ...\n"
    | 91 ->
        "I expected a 'BY INDUCTION ON l' here, but instead I found '$0'.\nHint: Proofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  ...\n"
    | 90 ->
        "I expected a 'BY INDUCTION ON l' here, but instead I found '$0'.\nHint: Proofs should be stated like this:\n  PROOF.\n  BY INDUCTION ON l.\n  ...\n"
    | 89 ->
        "I expected a '.' here, but instead I found '$0'. Did you forget to end 'PROOF' with '.'?\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 88 ->
        "I expected a 'PROOF.' here, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 87 ->
        "I expected a '.' here, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 86 ->
        "I expected a type here, but instead, I found '$0'.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 85 ->
        "I expected a ':' here followed by the type of the equational expression, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 83 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 82 ->
        "I expected a '=' here, but instead I found '$0'.\n"
    | 80 ->
        "I expected an 'end' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 79 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 78 ->
        "I expected a '=>' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 77 ->
        "I expected name to bind to the rest of the list here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 76 ->
        "I expected a '::' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 75 ->
        "I expected a name to bind to the head of the list here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 74 ->
        "I expected a '|' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 73 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 72 ->
        "I expected a '=>' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 71 ->
        "I expected a '[]' here, but instead I found '$0'. The empty list case should come first.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 70 ->
        "I expected a '|' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 69 ->
        "I expected a 'with' here, but instead I found '$0'.\nHint: Valid match expressions should be written like:\n  match l with\n  | [] => ...\n  | x::xs => ...\n  end\n"
    | 67 ->
        "I expected a ')' here, but instead I found '$0'. Did you forget to close the parenthesis?\n"
    | 65 ->
        "I expected an 'end' here, but instead I found '$0'.\nHint: Valid if expressions are written like:\n  if x then y else z end\n"
    | 64 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 63 ->
        "I expected an 'else' here, but instead I found '$0'.\nHint: Valid if expressions are written like:\n  if x then y else z end\n"
    | 62 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 61 ->
        "I expected a 'then' here, but instead I found '$0'.\nHint: Valid if expressions are written like:\n  if x then y else z end\n"
    | 59 ->
        "I expected an 'end' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 58 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 57 ->
        "I expected a '=>' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 55 ->
        "I expected an 'end' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 49 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 47 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 45 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 38 ->
        "I expected an expression here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 35 ->
        "I expected an 'end' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 34 ->
        "I expected an expression for the function body here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 33 ->
        "I expected a '=>' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 23 ->
        "I expected an expression for the lhs of the theorem statement here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 20 ->
        "I expected a ':', or more arguments here, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 18 ->
        "I expected one of '->', 'list', or ')' here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 9 ->
        "I expected a type here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 8 ->
        "I expected ':' here followed by a type for '$1', but instead I found '$0'.\n"
    | 7 ->
        "I expected an argument name here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 54 ->
        "I expected an expression for the function body here, but instead I found '$0'.\nHint: Valid expressions should evaluate to a value.\n"
    | 53 ->
        "I expected a '=>' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 52 ->
        "I expected one of '->', 'list', or ')' here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 51 ->
        "I expected a type here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 32 ->
        "I expected a ')', or a ':'followed by a type for '$1' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 31 ->
        "I expected an argument name here, but '$0' is not a valid name\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 30 ->
        "I expected an argument for 'fun' here, but instead I found '$0'.\nHint: Anonymous functions should be written like this:\n  fun (arg : type) => body end\n  or\n  fun (arg) => body end\n  or\n  fun arg => body end\n"
    | 28 ->
        "I expected an expression here, but '$0' is not part of a valid expression.\nHint: Valid expressions should evaluate to a value.\n"
    | 27 ->
        "I expected an expression here, but '$0' is not part of a valid expression.\nHint: Valid expressions should evaluate to a value.\n"
    | 26 ->
        "I expected an expression to pattern match on here, but '$0' is not part of a valid expression.\nHint: Valid expressions should evaluate to a value.\n"
    | 170 ->
        "I expected one of '->', 'list', or ')' here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 16 ->
        "I expected one of '->', 'list', or ')' here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 15 ->
        "I expected a type here, but '$0' is not a valid type.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 13 ->
        "I expected one of '->', 'list', or ')' here, but instead, I found '$0'. This looks like an invalid type declaration.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 12 ->
        "I expected a type here, but '$0' is not a valid type.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 169 ->
        "I expected a type for '$2' here, but '$0' is not a valid type.\nHint: Valid types are:\n  nat\n  'a\n  'a list\n  'a -> 'b\n  (where 'a and 'b are any valid types)\n"
    | 167 ->
        "I expected either a ')', or ':' followed by a type here, but instead I found '$0'.\n"
    | 166 ->
        "I expected an argument name here, but '$0' is not a valid name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  y_2\n  arg_name\n"
    | 6 ->
        "I expected a list of arguments here, but instead I found '$0'.\nHint: Did you forget a '('? Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 5 ->
        "I expected a 'FORALL' here, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 4 ->
        "I expected '.' here, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 3 ->
        "I expected ')' here, but instead I found '$0'. Did you forget to close the parenthesis?\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 2 ->
        "I expected a theorem name here, but '$0' is not a valid theorem name.\nHint: Valid names start with a lowercase letter, followed by alphanumeric characters including '_':\n  x\n  theorem2\n  erringtons_2nd_Theorem_of_Greatness\n"
    | 1 ->
        "I expected '(' here, but instead I found '$0'.\nHint: Theorems should be stated like this:\n  THEOREM (theorem_name).\n  FORALL (arg_1 : type_1) ... (arg_n : type_n) : lhs = rhs : expr_type.\n  PROOF.\n  ...\n"
    | 0 ->
        "I expected a statement here, but I got '$0'.\nHint: Valid statements are theorem, definition, and print statements.\n"
    | _ ->
        raise Not_found
