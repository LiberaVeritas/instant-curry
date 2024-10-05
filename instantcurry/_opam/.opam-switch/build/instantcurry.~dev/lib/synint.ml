exception NotImplemented

type name = string
type uv_name = string

type ty =
  | Ty_Nat
  | Ty_Arrow of ty * ty
  | Ty_List of ty

(* Terms in the object language. *)
type tm =
  | Nil of ty
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

type pattern = 
  | Pat_nil (* [] *)
  | Pat_cons of name * name (* x :: xs *)

let (++) a b = App (a, b)

type eqn = { lhs : tm; rhs : tm }

type thm_stmt = {
  quantifiers : (name * ty) list; (* variables universally quantified in the statement *)
  claim : eqn (* that the LHS = the RHS *)
}
(* ^ Morally this is a nested Pi-type of all the quantified names followed by an equation.
   This is essentially the syntax of types of the metalanguage. *)

(* IMPORTANT: the metalanguage does not really have a syntax of terms for now. *)

type justification =
    | ByDefinition (* To think about: how to specify which definition exactly? *)
    | ByTheorem of name

type step = (tm * justification)

type side = {
    start : tm;
    steps : step list
}

type case = {
    var : name;
    pattern : pattern;
    ihs : (name * eqn) list;
    wts : eqn;
    lhs : side;
    rhs : side;
}

type proof = 
| Proof of name * case list (* Induction variable, cases *)
| Axiom

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

type program = stmt list

