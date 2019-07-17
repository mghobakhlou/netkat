module type T = sig
  type t [@@deriving sexp, compare, hash]
end
