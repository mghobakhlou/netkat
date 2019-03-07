(** NetKAT: algebraic structure *)

open Base

module type S = sig
  
  (** carrier of KAT *)
  type t

  (** carrier of BA *)
  type b

  (** header value *)
  type hv

  (* pred is a Boolean algebra *)
  val tru : b
  val fls : b
  val test : hv -> b
  val neg : b -> b
  val conj : b -> b -> b
  val disj : b -> b -> b

  (* t is a Kleene algebra ... *)
  val union : t -> t -> t
  val seq : t -> t -> t
  val star : t -> t

  (* ...with tests... *)
  val filter : b -> t

  (* ...and network primitives *)
  val modify : hv -> t
  (* SJS: we exclude dup as it is not needed for local programs and can be added
     as an "extension"; see Generic_ast module. *)
  (* val dup : t *)

end

module type S' = sig
  
  (** carrier of KAT *)
  type t [@@deriving sexp, compare, hash]

  (** carrier of BA *)
  type b [@@deriving sexp, compare, hash]

  (** header value *)
  type hv [@@deriving sexp, compare, hash]

  include S with type t := t and type b := b and type hv := hv

end

type ('carrier, 'hv) t = (module S with type hv = 'hv and type t = 'carrier)
type ('carrier, 'hv) t' = (module S' with type hv = 'hv and type t = 'carrier)
