(** Algebraic signatures. *)

(** Boolean Algebra. *)
module type BA = sig
  type t
  val ctrue : t
  val cfalse : t
  val conj : t -> t -> t
  val disj : t -> t -> t
  val neg : t -> t
end

(** Kleene Algebra with Tests. *)
module type KAT = sig
  type b
  type t

  include BA with type t := b

  (** Kleene algebra ... *)

  val union : t -> t -> t
  val seq : t -> t -> t
  val star : t -> t

  (** ... with Tests. *)

  val assrt : b -> t

end
