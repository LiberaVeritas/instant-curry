open Core

exception NotImplemented

type name = string [@@deriving sexp]
type uv_name = string [@@deriving sexp]

type ty =
  | Ty_Nat
  | Ty_Arrow of ty * ty
  | Ty_List of ty
  | Ty_Tree of ty
  | Ty_Var of name
  [@@deriving sexp]
  
let rec ty_equal t1 t2 =
  match (t1, t2) with
  | Ty_Nat, Ty_Nat -> true
  | Ty_Arrow (s1, s2), Ty_Arrow (p1, p2) -> ty_equal s1 p1 && ty_equal s2 p2
  | Ty_List s, Ty_List p -> ty_equal s p
  | Ty_Tree s, Ty_Tree p -> ty_equal s p
  | Ty_Var s, Ty_Var p -> String.equal s p
  | _ -> false

(* Terms in the object language. *)
type tm =
  | Nil 
  | Cons of tm * tm
  | ListCase of tm (* scrutinee *) * tm (* nil case *) * name * name * tm (* cons case (and its two bound vars) *)
  | Nat of int
  | Plus of tm * tm
  | Minus of tm * tm
  | Times of tm * tm
  | If0 of tm (* scrutinee *) * tm (* zero case *) * tm (* successor case *)
  | App of tm * tm
  | Fun of name * ty * tm (* anonymous function *)
  | BVar of name (* A bound variable *)
  | Ref of name (* A free variable, e.g. a self-reference in a recursive function. *)
  | UVar of uv_name (* A unification variable *)
  | MVar of name
    (* A meta variable, referring to a quantified variable in the metalanguage. *)
  [@@deriving sexp]

let rec tm_equal tm1 tm2 =
  match (tm1, tm2) with
  | Nil, Nil -> true
  | Cons (a1, a2), Cons (b1, b2) -> tm_equal a1 b1 && tm_equal a2 b2
  | Nat a, Nat b -> a = b
  | Plus (a1, a2), Plus (b1, b2) -> tm_equal a1 b1 && tm_equal a2 b2
  | Minus (a1, a2), Minus (b1, b2) -> tm_equal a1 b1 && tm_equal a2 b2
  | Times (a1, a2), Times (b1, b2) -> tm_equal a1 b1 && tm_equal a2 b2
  | App (a1, a2), App (b1, b2) -> tm_equal a1 b1 && tm_equal a2 b2
  | If0 (a1, a2, a3), If0 (b1, b2, b3) -> tm_equal a1 b1 && tm_equal a2 b2 && tm_equal a3 b3
  | Fun (a1, a2, a3), Fun (b1, b2, b3) -> String.equal a1 b1 && ty_equal a2 b2 && tm_equal a3 b3
  | BVar a, BVar b -> String.equal a b (* A bound variable *)
  | Ref a, Ref b -> String.equal a b (* A free variable, e.g. a self-reference in a recursive function. *)
  | UVar a, UVar b -> String.equal a b (* A unification variable *)
  | MVar a, MVar b -> String.equal a b
    (* A meta variable, referring to a quantified variable in the metalanguage. *)
  | _ -> false

type pattern = 
  | Pat_nil (* [] *)
  | Pat_cons of name * name (* x :: xs *)
  (*| Pat_empty*)
  (*| Pat_node of name * name * name*)
  [@@deriving sexp]

let (++) a b = App (a, b)

type eqn = { lhs : tm; rhs : tm } [@@deriving sexp]

type claim = {
  eqn : eqn;
  ty : ty
} [@@deriving sexp]

type thm_stmt = 
{
  quantifiers : (name * ty) list; (* variables universally quantified in the statement *)
  claim : claim (* that the LHS = the RHS *)
}

[@@deriving sexp]
(* ^ Morally this is a nested Pi-type of all the quantified names followed by an equation.
   This is essentially the syntax of types of the metalanguage. *)

(* IMPORTANT: the metalanguage does not really have a syntax of terms for now. *)

type justification =
    | ByDefinition (* To think about: how to specify which definition exactly? *)
    | ByTheorem of name
    | ByIH of name
    | ByCommonsense
    [@@deriving sexp]

type step = (tm * justification) [@@deriving sexp]

type side = {
    start : tm;
    steps : step list
}
[@@deriving sexp]

type case = {
    var : name;
    pattern : pattern;
    ihs : (name * eqn) list;
    wts : eqn;
    lhs : side;
    rhs : side;
}
[@@deriving sexp]

type proof = 
| Proof of name * case list (* Induction variable, cases *)
| Axiom
[@@deriving sexp]

type stmt = 
  | Thm of {
    name : string;
    stmt : thm_stmt;
    proof : proof;
  }
  | Definition of {
    name : string;
    isrec : bool;
    args : (name * ty) list;
    rty : ty;
    fnsig : ty;
    body : tm
  }
  | Print of tm
  [@@deriving sexp]

type program = stmt list [@@deriving sexp]

