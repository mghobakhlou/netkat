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


let interp_bexp
  ~(ba : 'b Sig.ba)
  ~(interp_test : 'test -> 'b)
  (bexp : 'test bexp) : 'b
=
  let rec interp = function
    | True -> ba.ctrue
    | False -> ba.cfalse
    | Test t -> interp_test t
    | Conj (b1, b2) -> ba.conj (interp b1) (interp b2)
    | Disj (b1, b2) -> ba.disj (interp b1) (interp b2)
    | Neg b -> ba.neg (interp b)
  in
  interp bexp

let interp_exp
  ~(kat : ('k, 'b) Sig.kat)
  ~(interp_test : 'test -> 'b)
  ~(interp_act : 'act -> 'k)
  (exp : ('act, 'test) exp) : 'k
=
  let rec interp = function
    | Assert bexp -> kat.assrt (interp_bexp ~ba:kat.ba ~interp_test bexp)
    | Action act -> interp_act act
    | Union (e1, e2) -> kat.union (interp e1) (interp e2)
    | Seq (e1, e2) -> kat.seq (interp e1) (interp e2)
    | Star e -> kat.star (interp e)
  in
  interp exp
