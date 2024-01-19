type name = string
type uv_name = string
type index = int

(* Terms in the object language. *)
type tm =
  | Nil
  | Cons of tm * tm
  | ListCase of tm (* scrutinee *) * tm (* nil case *) * tm (* cons case *)
  | Nat of int
  | Plus of tm * tm
  | Eq of tm * tm
  | App of tm * tm
  | Fun of name * tm
  | BVar of name * index (* A bound variable; the name is for display only *)
  | Ref of name (* A free variable, e.g. a self-reference in a recursive function. *)
  | UVar of uv_name (* A unification variable *)
  | MVar of name * index
    (* A meta variable, referring to a quantified variable in the metalanguage. *)

let (++) a b = App (a, b)

type eqn = { lhs : tm; rhs : tm }

type stmt = {
  quantifiers : name list; (* variables universally quantified in the statement *)
  claim : eqn (* that the LHS = the RHS *)
}
(* ^ Morally this is a nested Pi-type of all the quantified names followed by an equation.
   This is essentially the syntax of types of the metalanguage. *)

(* IMPORTANT: the metalanguage does not really have a syntax of terms for now. *)

type justification =
    | ByDefinition (* To think about: how to specify which definition exactly? *)
    (* TODO add other ones *)

type side = (tm * justification) list

type case = {
    var : name;
    pattern : tm;
    ihs : eqn list;
    wts : eqn;
    lhs : side;
    rhs : side;
}

type proof = name * case list (* Induction variable, cases *)

type thm = {
    name : string;
    stmt : stmt;
    proof : proof;
}

type program = thm list
