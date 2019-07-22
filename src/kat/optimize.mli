(** Smart constructors and algebraic optimization for KAT. *)

open Base
open Ast


(** {2 Constants}  *)

val ctrue : 'test bexp
val cfalse : 'test bexp

val skip : ('act, 'test) exp
val abort : ('act, 'test) exp


(** {2 Smart constructors}  *)

val conj : 'test bexp -> 'test bexp -> 'test bexp
val disj : 'test bexp -> 'test bexp -> 'test bexp
val neg : 'test bexp -> 'test bexp

val assrt : 'test bexp -> ('act, 'test) exp
val union : ('act, 'test) exp -> ('act, 'test) exp -> ('act, 'test) exp
val seq : ('act, 'test) exp -> ('act, 'test) exp -> ('act, 'test) exp
val star : ('act, 'test) exp -> ('act, 'test) exp


(** {2 Algebraic optimization}  *)

val optimize_bexp : ?negate:bool -> 'test bexp -> 'test bexp
val optimize_exp : ('act, 'test) exp -> ('act, 'test) exp
