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
  | (Ty_Nat, Ty_Nat) -> true
  | (Ty_Arrow (s1, s2), Ty_Arrow (p1, p2)) -> ty_equal s1 p1 && ty_equal s2 p2
  | (Ty_List s, Ty_List p) -> ty_equal s p
  | (Ty_Tree s, Ty_Tree p) -> ty_equal s p
  | (Ty_Var s, Ty_Var p) -> String.equal s p
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

type pattern = 
  | Pat_nil (* [] *)
  | Pat_cons of name * name (* x :: xs *)
  | Pat_empty
  | Pat_node of name * name * name
  [@@deriving sexp]

let (++) a b = App (a, b)

type eqn = { lhs : tm; rhs : tm } [@@deriving sexp]

type thm_stmt = {
  quantifiers : (name * ty) list; (* variables universally quantified in the statement *)
  claim : eqn (* that the LHS = the RHS *)
}
[@@deriving sexp]
(* ^ Morally this is a nested Pi-type of all the quantified names followed by an equation.
   This is essentially the syntax of types of the metalanguage. *)

(* IMPORTANT: the metalanguage does not really have a syntax of terms for now. *)

type justification =
    | ByDefinition (* To think about: how to specify which definition exactly? *)
    | ByTheorem of name
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

