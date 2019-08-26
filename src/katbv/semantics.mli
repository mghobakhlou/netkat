open Base

module Env : sig
  type t = (string, Bitstring.t) Hashtbl.t [@@deriving sexp]
  include Comparator.S with type t := t
end

type env_set = Set.M(Env).t

val eval : env:Env.t -> Ast.exp -> env_set