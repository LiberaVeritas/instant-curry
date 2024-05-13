open Icparser.Parsed_ast
open Buffer

type trans_err_reason = 
  | BadIndVar
  | BadIndTy
  | LhsRhsDisagree
exception TranslationError of trans_err_reason

let translate_ty (ty : ty) (buf : Buffer.t) : unit =
  let add = add_string buf in
  let rec go ty = 
    add "(";
    begin match ty with
    | Ty_Nat -> add "nat"
    | Ty_Arrow (ty, ty') -> go ty; add " -> "; go ty'
    | Ty_List ty -> add "list "; go ty
    | Ty_Tree ty -> add "tree "; go ty
    | Ty_var x -> add x
    end;
    add ")"
  in go ty

let translate_tm (t : tm) (buf : Buffer.t) : unit = 
  let add = add_string buf in
  let rec go t = 
    add "(";
    begin match t with
    | Nil -> add "Nil"
    | Cons (x, xs) -> add "Cons "; go x; add " "; go xs
    | Empty -> add "Empty"
    | Node (l, x, r) -> add "Node "; go l; add " "; go x; add " "; go r
    | ListCase (l, n, x, xs, c) -> 
      add "match "; go l; add " with ";
      add "| Nil => "; go n; 
      add (" | Cons " ^ x ^ " " ^ xs ^ " => "); go c; add " end"
    | TreeCase (t, e, lx, vx, rx, n) ->
      add "match "; go t; add " with ";
      add "| Empty => "; go e; 
      add (" | Node " ^ lx ^ " " ^ vx ^ " " ^ rx ^ " => "); go n; add " end"
    | Nat n -> add @@ string_of_int n
    | Plus (n, m) -> add "plus "; go n; add " "; go m
    | Minus (n, m) -> add "minus "; go n; add " "; go m
    | Times (n, m) -> add "times "; go n; add " "; go m
    | If0 (n, z, s) ->
      add "match "; go n; add " with ";
      add "| Z => "; go z; 
      add (" | S _ => "); go s; add " end" 
    | App (t, t') -> go t; add " "; go t'
    | Fun (x, _, b) -> 
      add "fun "; add x; add " => "; go b
    | Var x -> add x
    end;
    add ")"
  in go t

let rec collect l ty =
  match ty with 
  | Ty_Nat -> []
  | Ty_Arrow (ty, ty') -> collect (collect l ty) ty'
  | Ty_List ty | Ty_Tree ty -> collect l ty
  | Ty_var x -> if List.mem x l then l else x :: l

let translate_eqn ((lhs, rhs) : eqn) (buf : Buffer.t) : unit =
  let add = add_string buf in
  add "("; translate_tm lhs buf; add " = "; translate_tm rhs buf; add ")" 

let translate_just (tm : tm) (ety : ty) (s : string) (buf : Buffer.t) : unit =
  let add = add_string buf in
  match s with
  | "defn" -> add "next_refl ("; translate_tm tm buf; 
              add " : "; translate_ty ety buf;
              add ").\n"
  | "commonsense" ->  add "next_lia ("; translate_tm tm buf; 
                      add " : "; translate_ty ety buf;
                      add ").\n"
  | _ ->  add "next_hyp ("; translate_tm tm buf; 
          add " : "; translate_ty ety buf; add ") ";
          add s; add ".\n"
  (* if s = "defn" then add "simpl.\n" else begin add "erewrite "; add s; add ".\n" end *)

let translate_case (c : case) (ety : ty) (buf : Buffer.t) : unit =
  let rec last x = function
  | [] -> x
  | x :: xs -> last x xs
  in 
  let add = add_string buf in
  let (_, pat, _ihs, _, (lh1, lhs), (rh1, rhs)) = c in
  begin match pat with
  | Pat_cons (x, xs) -> add "rename x into "; add x; add ".\n";
                        add "rename xs into "; add xs; add ".\n";
  | Pat_node (l, x, r) -> add "rename l into "; add l; add ".\n";
                          add "rename x into "; add x; add ".\n";
                          add "rename r into "; add r; add ".\n";
  | _ -> ();
  end;
  let last_lhs = last lh1 (List.map fst lhs) in
  let last_rhs = last rh1 (List.map fst rhs) in
  if last_lhs <> last_rhs then raise (TranslationError LhsRhsDisagree);
  add "apply lhs_is_rhs with (C := "; translate_tm last_lhs buf; add ").\n";
  let translate_side side = List.iter (fun (tm, just) -> translate_just tm ety just buf) side in
  add "-- "; translate_side lhs; add "reflexivity. \n";
  add "-- "; translate_side rhs; add "reflexivity. \n"

let translate_proof (p : proof) (ety : ty) (args: (name * ty) list) (buf : Buffer.t) : unit =
  let add = add_string buf in
  match p with
  | Axiom -> add "Admitted.\n"
  | Proof (ivar, gvs, cs) -> 
    let indty = try List.assoc ivar args with
    | Not_found -> raise (TranslationError BadIndVar) in
    let intropat = match indty with
    | Ty_List _ -> "[| x xs IH1 ]"
    | Ty_Tree _ -> "[| l x r IH1 IH2 ]" 
    | _ -> raise (TranslationError BadIndTy) in
    begin match gvs with
    | None -> ()
    | Some gvs -> List.iter (fun gv -> add "generalize dependent "; add gv; add ".\n") gvs
    end;
    add "induction "; add ivar; add " as "; add intropat; add "; intros.\n";
    List.iter (fun c -> add "- "; translate_case c ety buf; add "\n") cs;
    add "Qed.\n"

let translate_stmt (s : stmt) (buf : Buffer.t) : unit = 
  let add = add_string buf in
  let go s = 
    match s with
    | Theorem (name, args, (eqn, ety), proof) -> 
      add "Theorem "; add name; add " ";
      let ptys = List.fold_left collect [] (List.map snd args) in
      if List.length ptys > 0 then
        begin add "{"; List.iter (fun x -> add x; add " ") ptys; add ": Set} " end;
      List.iter (fun (x, ty) -> add "("; add x; add " : "; translate_ty ty buf; add ") ") args;
      add ": "; translate_eqn eqn buf; add ".\n";
      add "Proof. \n";
      translate_proof proof ety args buf;
    | Definition (name, isrec, args, rty, b) -> 
      begin if isrec then add "Fixpoint " else add "Definition "; add name; add " " end;
      let ptys = List.fold_left collect [] (List.map snd args) in
      if List.length ptys > 0 then
        begin add "{"; List.iter (fun x -> add x; add " ") ptys; add ": Set} " end;
      List.iter (fun (x, ty) -> add "("; add x; add " : "; translate_ty ty buf; add ") ") args;
      add ": "; translate_ty rty buf; add " := ";
      translate_tm b buf; add ".\n"
    | Print _ -> ()
  in go s

let rec print_prog (p : program) (out : out_channel) : unit =
  match p with 
  | [] -> ()
  | s :: p -> 
    let buf = Buffer.create 2048 in
    translate_stmt s buf;
    Buffer.output_buffer out buf;
    print_prog p out
