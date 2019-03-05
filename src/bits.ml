(** Bitstrings.
    A shallow overlay of the bistring library: https://bitstring.software/ *)

open Base
include Bitstring
include Sexpable.Of_stringable(struct
  include Bitstring
  let to_string = string_of_bitstring
  let of_string = bitstring_of_string
end)

(* SJS: not obvious how to implement these efficiently. Better punt on it for now. *)
let hash_fold_t _ _ = failwith "not implemented"
let hash _ = failwith "not implemented"
