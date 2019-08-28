open Base

module Env : sig
  (* env is a map from strings (fields) to bit strings *)
  type t = (string, Bitstring.t) Hashtbl.t [@@deriving sexp]
  include Comparator.S with type t := t
end

(* [of_str_lst lst] is [env] where [x] maps to [Bistring.of_binary v] in [env] 
   if [(x,v)] is in [lst] *)
val of_str_lst : (string * string) list -> Env.t

type env_set = Set.M(Env).t

val to_str_lst : env_set -> (string * string) list list

(* [eval ~env exp] is the set of mappings from field values to bit strings 
   produced by [exp] evaluated on [env]. Note that fields unspecified by [env]
   are assumed to be 0. *)
val eval : env:Env.t -> Ast.exp -> env_set