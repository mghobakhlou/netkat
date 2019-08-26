open Base

module Env : sig
  (* env is a map from strings (fields) to bit strings *)
  type t = (string, Bitstring.t) Hashtbl.t [@@deriving sexp]
  include Comparator.S with type t := t
end

type env_set = Set.M(Env).t

(* [eval ~env exp] is the set of mappings from field values to bit strings 
   produced by [exp] evaluated on [env]. Note that fields unspecified by [env]
   are assumed to be 0. *)
val eval : env:Env.t -> Ast.exp -> env_set