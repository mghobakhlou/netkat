(** Generic AST for Kleene Algebra with Tests (KAT). *)


(** {2 Expressions} *)

(** Boolean expressions, paramerized by primitive tests ['test]. *)
type 'test bexp =
  | True
  | False
  | Test of 'test
  | Conj of ('test bexp) * ('test bexp)
  | Disj of ('test bexp) * ('test bexp)
  | Neg of 'test bexp
  [@@deriving sexp, compare, equal, hash]

(** KAT expressions, paramerized by actions ['act] and primitive tests ['test]. *)
type ('act, 'test) exp =
  | Assert of 'test bexp
  | Action of 'act
  | Union of ('act, 'test) exp * ('act, 'test) exp
  | Seq of ('act, 'test) exp * ('act, 'test) exp
  | Star of ('act, 'test) exp
  [@@deriving sexp, compare, equal, hash]


(** {2 Homomorphisms} *)

val interp_bexp :
  ba:'b Sig.ba -> interp_test:('test -> 'b)
  -> 'test bexp -> 'b

val interp_exp :
  kat:('k,'b) Sig.kat -> interp_test:('test -> 'b) -> interp_act:('act -> 'k) 
  -> ('act, 'test) exp -> 'k