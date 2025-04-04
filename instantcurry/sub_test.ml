
open Instantcurry
open Synint
open Term


type t = {from:tm; into:tm; within:tm}

let check ex sol =
  ( = ) (subst_expr ex.from ex.into ex.within) sol

let ex1 = 
  {
    from = (BVar "x");
    into = (Cons (MVar "y", Cons (Nat 1, Nil)));
    within = (Fun ("x", Ty_Nat, Fun ("y", Ty_Nat, BVar "x")));
  }
let ex1_sol =
  (Fun ("x", Ty_Nat,
    Fun ("y", Ty_Nat,
     BVar "x")))

let%test "sub1" =
  check ex1 ex1_sol
  

let ex2 =
{
  from = (MVar "y");
  into = Plus (Nat 1, (MVar "x"));
  within = (Fun ("x", Ty_Nat, Fun ("z", Ty_Nat, MVar "y")));
}

let ex2_sol =
  (Fun ("x~1", Ty_Nat,
    Fun ("z", Ty_Nat,
     (Plus (Nat 1, (MVar "x"))))))

let%test "sub2" =
  check ex2 ex2_sol
