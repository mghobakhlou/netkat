open Idd_
open Ast

val compile_pol : Idd.manager -> (string -> int) -> expr -> Idd.t

val compile_pred : Bdd.manager -> (string -> int) -> bexpr -> Bdd.t