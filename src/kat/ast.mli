(** Generic AST for Kleene Algebra with Tests (KAT). *)


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

