# InstantCurry
An friendly educational proof checker for COMP 302.

Allows for stating and proving inductive and arithmetic statements, with polymorphpic type checking and inference.

## Syntax
An InstantCurry program is a list of statements.
```
<program> ::= <statement> <program> | EOF
```
Statements consist of definitions and theorems.
```
<statement> ::= <definition> | <theorem> | <print>
```

#### Comments
Comments may be written like in OCaml, or as a line comment starting with `#` until the end of the line.
```
(* OCaml style comment *)
# line comment
```
## Operational (Big Step) Semantics
Evaluation follows standard arithmetic on the naturals, along with function applications, or β-reductions.

## Types
InstantCurry has 2 basic computational types, natural numbers and functions, as well as an inductive list type.
```
type nat := {0, 1, 2, ...}
type 'a list := [] | 'a :: 'a list
type 'a -> 'b := <function>
```
Type variables are denoted by a single quote followed by a variable name, like `'a`. This can stand for any InstantCurry type, thus giving a type schemes parametrized over types.

#### Functions
Functions in InstantCurry are pure functions, or mappings from one type to another.
Internally, all functions are single variable, which means functions with multiple arguments are automatically curried.
```
f : 'a -> 'b -> 'a
f 5 : 'b -> nat
```

## Definitions
Definitions basically represent named lambda abstractions.
They can be used to define functions, using definition declaration header and a basic syntax similar to that of OCaml.
```
DEFINITION.
let id x = x
```
Argument and return type annotations are optional.
```
DEFINITION.
let id (x : 'a) : 'a = x

DEFINITION.
let rec map (f : 'a -> 'b) (l : 'a list) : 'b list =
    match l with
    | [] => []
    | x :: xs => f x :: (map f xs)
    end

DEFINITION.
let rec len (l : 'a list) : nat =
    match l with
    | [] => 0
    | x :: xs => 1 + len xs
    end
```
Note the double arrow `=>` instead of `->` in the match expression, and the mandatory `end`.

## Theorems
Theorems in InstantCurry are inductive and universally quantified.
They are stated along with a name, which can later be referred to in a proof, along with a list of variables to quantify over and the statement of the theorem (equation). 
```
THEOREM (map_id).
FORALL (l : 'a list) : 
map id l = l : 'a list. 

PROOF.
...

...
THEOREM (map_len).
FORALL (l : 'a list) (f : 'a -> 'b) : 
len (map f l) = len l : nat.

PROOF.
...
```
Type annotations are required for theorem statements and variables.

## Proofs
The simplest proof is to assume the theorem by axiom.
```
THEOREM (map_id).
FORALL (l : 'a list) : 
map id l = l : 'a list. 

PROOF.
AXIOM.
```
Mainly, proofs in InstantCurry are by induction on lists.
This is broken down into the base (empty list) case, and the inductive (arbitrary list) case.
```
THEOREM (map_id).
FORALL (l : 'a list) : 
map id l = l : 'a list. 

PROOF. 
BY INDUCTION ON l.                  

CASE l = [].              # empty list case
WTS: map id [] = [].      # optional

LHS = map id [].          # left hand side of WTS
    = []               -- BY defn.

RHS = [].                 # right hand side of WTS
...
```
For each case, there is a 'want to show' statement `WTS`, which is the statement to prove.
This can be omitted and inferred by InstantCurry.

Each side of the `WTS` is stated, followed by deductive steps to make them equal.
Every step is justified by a deductive rule, stated like `-- BY <justification>`.
```
CASE l = y :: ys.
IH1: map id ys = ys.                # inductive hypothesis
WTS: map id (y :: ys) = y :: ys.

LHS = map id (y :: ys).
    = id y :: map id ys             -- BY defn.
    = y :: map id ys                -- BY defn of id.
    = y :: ys                       -- BY IH1.

RHS = y :: ys.

QED.
```
List cases are accompanied by inductive hypotheses. (`IH` followed by a number) These hypotheses assume the statement of the theorem for list of length one less than the list of consideration. That is, given a list `x::xs`, the hypothesis takes as granted the theorem statement for `xs`.
Proofs by induction come down to demonstrating how to integrate the next element `x` under this assumption.

The end of proofs are marked by `QED.`.

## Justifications
There are several ways to justify a deductive proof step.
```
THEOREM (map_len).
FORALL (l : 'a list) (f : 'a -> 'b) : 
len (map f l) = len l : nat.

PROOF.
BY INDUCTION ON l.

CASE l = [].
WTS: len (map f []) = len [].

LHS = len (map f []).
    = len []                        -- BY defn.

RHS = len [].
...
```
#### By Definition
This is the application of the definition of a function in the previous step, to derive the next step.

A specific function to use can be specified with `-- BY defn of <fun_name>`.
```
    = len (map f []).
    = len []                        -- BY defn of map.
```
Otherwise, with `-- BY defn.`, InstantCurry will automatically try all possible functions.

Note that only one instance of applying a function definition will be considered at a time:
```
    = map f (map g []).
    = map f []                  -- BY defn.
    = []                        -- BY defn.
```

#### By Inductive Hypothesis

```
...
CASE l = x :: xs.
IH1: len (map f xs) = len xs.
WTS: len (map f (x :: xs)) = len (x :: xs).

LHS = len (map f (x :: xs)).
    = len (f x :: map f xs)         -- BY defn.
    = 1 + len (map f xs)            -- BY defn.
    = 1 + len xs                    -- BY IH1.
...
```
This applies the statement of the hypothesis.
As this is an equation, either the lhs or the rhs can be applied.


#### By Theorem
A previously proven theorem can be referred to by name, and have its statement be applied in a step, using `-- BY <theorem_name>`.
```
    = 1 + len (map f (x :: map id xs)).
    = 1 + len (map f (x :: xs))     -- BY map_id.
    = 1 + len (x :: xs)             -- BY map_len.
```

#### By Common Sense
Common sense encompasses some basic properties of arithmetic on natural numbers:
```
Commutativity:
a + b = b + a
a * b = b * a

Additive identity:
a + 0 = a
0 + a = a

Multiplicative identity:
a * 1 = a
1 * a = a

Associativity:
(a + b) + c = a + (b + c)
(a * b) * c = a * (b * c)
f (g x) = (f g) x
```
Used with `-- BY commonsense.`.

Examples:
```
LHS = sum [] + acc.
    = 0 + acc           -- BY defn.
    = acc               -- BY commonsense.
```

```
LHS = sum (x :: xs) + acc.
    = x + sum xs + acc      -- BY defn.
    = sum xs + x + acc      -- BY commonsense.

    = sum xs + (x + acc)      -- BY commonsense.
```
## Generalization
Some proofs require a generalization of the statement.
For example, the proof that the `sum` function is equivalent to the tail recursive version `sum_tr`.
```
THEOREM (sum_is_sum_tr).
FORALL (l : nat list) :
    sum l = sum_tr l 0 : nat.

PROOF. BY INDUCTION ON l.       # attempt

CASE l = x :: xs.
IH1: sum xs = sum_tr xs 0.
WTS: sum (x :: xs) = sum_tr (x :: xs) 0.

LHS = sum (x :: xs).
    = x + sum xs            -- BY defn.
    = sum xs + x            -- BY commonsense.

RHS = sum_tr (x :: xs) 0.
    = sum_tr xs (x + 0)     -- BY defn.
    = sum_tr xs x           -- BY commonsense.
    = ???
...
```
Instead, we can generalize `0` to a more general `acc` which can be any natural number:
```
THEOREM (sum_is_sum_tr).
FORALL (l : nat list) (acc : nat) :         # <----
    sum l + acc = sum_tr l acc : nat.

PROOF. BY INDUCTION ON l, GENERALIZE acc.   # <----

CASE l = x :: xs.
IH1: sum xs + acc = sum_tr xs acc.
WTS: sum (x :: xs) + acc = sum_tr (x :: xs) acc.

LHS = sum (x :: xs) + acc.
    = x + sum xs + acc      -- BY defn.
    = sum xs + x + acc      -- BY commonsense.
    = sum xs + (x + acc)    -- BY commonsense.

RHS = sum_tr (x :: xs) acc.
    = sum_tr xs (x + acc)   -- BY defn.
    = sum xs + (x + acc)    -- BY IH1.
...
```
Note the comma after `BY INDUCTION ON l,` followed by `GENERALIZE <vars>...`.


## TODO
* useful error messages to UI for typechecking, lifting, proof checking.
* distributivity for commonsense?
* induction over naturals?
* remove requirement for a number after `IH`. are multiple IHs ever needed?
* check IHs are valid.
* check there are two cases, one of base and list each. (are there any situations where this isn't the case?) 
* automated theorem prover.



## Errors
Syntax errors throw ParserUtil.SyntaxError with a JSON string with fields.
```
line: line number in source where error occured
start: error token start, in number of characters within line
stop: error token stop, in number of characters within line
message: error message
state: internal parser state that led to the error
advice: advice for fixing error
```
Note: a start position of 0 could mean the error happened at the end of the last line

Note: the error token range can be 0 (start = stop)

`message` can be `<YOUR SYNTAX ERROR MESSAGE HERE>` when a specific messsage doesn't exist. The state number is useful to report to help find where and how the error happened.

`message` and `advice` can both be empty strings.



## Build and run
Build using `dune build`.
Run against a file with `./run <file>`.
Use `./run_tests` to run on all files in the `sample` and `proofs` directories.
Definitions and theorems from `common.ic` are automatically loaded.
