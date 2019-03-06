type t = |
let absurd (t:t) = match t with _ -> .
let sexp_of_t = absurd
let t_of_sexp _ = failwith "impossible"
let compare = absurd
let equal = absurd
let hash = absurd
let hash_fold_t _ = absurd
