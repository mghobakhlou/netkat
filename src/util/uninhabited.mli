(** The empty (aka uninhabited) type.  *)

open Base

type t = |

include Sexpable.S with type t := t
val absurd : t -> 'a
val compare : t -> t -> int
val equal : t -> t -> bool
val hash : t -> Hash.hash_value
val hash_fold_t : Hash.state -> t -> Hash.state
