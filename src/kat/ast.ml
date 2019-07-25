open Base

type 'test bexp =
  | True
  | False
  | Test of 'test
  | Conj of ('test bexp) * ('test bexp)
  | Disj of ('test bexp) * ('test bexp)
  | Neg of 'test bexp
  [@@deriving sexp, compare, equal, hash]

type ('act, 'test) exp =
  | Assert of 'test bexp
  | Action of 'act
  | Union of ('act, 'test) exp * ('act, 'test) exp
  | Seq of ('act, 'test) exp * ('act, 'test) exp
  | Star of ('act, 'test) exp
  [@@deriving sexp, compare, equal, hash]

module Nary = struct

  type 'test bexp =
    | Test of 'test
    | Conj of 'test bexp list
    | Disj of 'test bexp list
    | Neg of 'test bexp
    [@@deriving sexp, compare, equal, hash]

  type ('act, 'test) exp =
    | Assert of 'test bexp
    | Action of 'act
    | Union of ('act, 'test) exp list
    | Seq of ('act, 'test) exp list
    | Star of ('act, 'test) exp
    [@@deriving sexp, compare, equal, hash]

end
