Require Import Init. Import Datatypes.
Require Import Arith.
Require Import Psatz.

Ltac next_refl t2 :=
    match goal with 
    | |- ?t1 = _ => 
        assert (H : t1 = t2) by reflexivity;
        rewrite H; clear H
    end.

Ltac next_hyp t2 Hyp :=
    match goal with
    | |- ?t1 = _ => 
        assert (H : t1 = t2) by (rewrite Hyp; reflexivity);
        rewrite H; clear H
    end.

Ltac next_lia t2 :=
    match goal with 
    | |- ?t1 = _ => 
        assert (H : t1 = t2) by lia;
        rewrite H; clear H
    end.

Lemma lhs_is_rhs : forall {T : Type} (A B C : T), 
    A = C -> B = C -> A = B.
Proof.
    intros. rewrite H. rewrite H0. reflexivity.
Qed.

Inductive list (A : Type) : Type :=
| Nil : list A
| Cons : A -> list A -> list A.

Arguments Nil {A}.
Arguments Cons {A} a l.

Fixpoint map {B A : Set} (f : ((A) -> (B))) (l : (list (A))) : (list (B)) := (match (l) with | Nil => (Nil) | Cons x xs => (Cons ((f) (x)) (((map) (f)) (xs))) end).
Fixpoint app {A : Set} (l1 : (list (A))) (l2 : (list (A))) : (list (A)) := (match (l1) with | Nil => (l2) | Cons x xs => (Cons (x) (((app) (xs)) (l2))) end).
Fixpoint rev {A : Set} (l : (list (A))) : (list (A)) := (match (l) with | Nil => (Nil) | Cons x xs => (((app) ((rev) (xs))) (Cons (x) (Nil))) end).
Fixpoint filter {A : Set} (f : A -> bool) (l : list A) := match l with | Nil => Nil | Cons x xs => if (f x) then (Cons x (filter f xs)) else (filter f xs) end.
Theorem assoc {A : Set} (l1 : list A) (l2 : list A) (l3 : list A) : app (app l1 l2) l3 = app l1 (app l2 l3).
Admitted.