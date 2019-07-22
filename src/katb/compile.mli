open Idd_
open Ast

(** [compile_pol mgr label expr] is the IDD representing [expr] where [label]
    maps packet header names to their respective variable index *)
val compile_pol : Idd.manager -> label:(string -> int) -> expr -> Idd.t

(** [compile_pred mgr label expr] is the BDD representing [expr] where [label]
    maps packet header names to their respective variable index *)
val compile_pred : Bdd.manager -> label:(string -> int) -> bexpr -> Bdd.t