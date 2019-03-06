(** Concrete ASTs *)

module Ext : sig
  type t = Dup
    [@@deriving sexp, compare, hash]
end

module Hv : sig
  type t = string * int64 [@@deriving sexp, compare, hash]
end

include Netkat.S with
  type hv = Hv.t and
  type b = Hv.t Generic_ast.pred and
  type t = (Ext.t, Hv.t) Generic_ast.pol

val as_netkat : (t, Hv.t) Netkat.t
