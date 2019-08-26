
type test =
  | Interval of string * Bitstring.t * Bitstring.t
  | Test of string * Bitstring.t * Bitstring.t
type act = string * Bitstring.t * Bitstring.t 
(* act (v, z, n) is a vector v' such that (v')_i=0 if i\in z, (v')_i=1 if i\in n
   and otherwise (v')_i=(v)_i *)
type bexp = test Kat.Ast.bexp
type exp = (act, test) Kat.Ast.exp


