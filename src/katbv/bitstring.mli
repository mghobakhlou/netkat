open Base

(** {2 Type} *)

(* the type of a bitstring. AF: the table [H] represents a bitvector [v] where
   [v_i]=1 iff [(i, ())] is in [H]. Note that bitstrings are interpreted left 
   to right as highest bit to lowest bit. So the string 110 is the binary
   representation of 6 and (100)_0 = 0 whereas (100)_2 = 1 *)
type t [@@deriving sexp]
include Comparator.S with type t := t


(** {2 Constructors} *)

val zero : t

(* [of_bool_list lst bv] is the bit string representation of [lst] *)
val of_bool_list : bool list -> t

(* [of_int_list lst bv] the bit string [v] where [v_i]=1 iff i is in [lst] *)
val of_int_list: int list -> t

(** {2 Basic Operations} *)

val max : t -> int option

val min : t -> int option

(* [v**v'] is bitwise multiplication of [v] and [v'] *)
val ( ** ) : t -> t -> t

(* [v++v'] is bitwise addition *)
val ( ++ ) : t -> t -> t

(* [v -- v'] is subtraction *)
val ( -- ) : t -> t -> t

val xor : t -> t -> t

(* tests whether v=0 *)
val is_zero : t -> bool

val equal : t -> t -> bool

(* [nth v i] is true iff [v_i]=1  *)
val nth : t -> int -> bool

(* {2 KAT+B! functions} *)

(* [lower_bound s a] is KAT+B! Boolean expression that is satisfied by [s:=v]
   iff v>=a where [s] is the variable name *)
val lower_bound : string -> t -> Katbb_lib.Ast.bexp

(* [upper_bound s b] is KAT+B! Boolean expression that is satisfied by [s:=v]
   iff [v]<=[b] where [s] is the variable name *)
val upper_bound : string -> t ->  Katbb_lib.Ast.bexp

(* [build_term_list s z n] is KAT+B! Boolean expression that is satisfied by [s:=v]
   iff [v_i=0] for all i such that [z_i=1] and [v_i=1] for all i such that 
   [n_i=1] *)
val build_term_list : string -> t -> t -> 
  (bool -> int -> 'a) -> 'a list

(* {2 Rendering} *)
val to_string : t -> string