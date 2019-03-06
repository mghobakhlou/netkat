(** A concrete AST is obtained from the generic AST module by fixing:
      - the type of extensions
      - the type of "header values"
*)

open Base

(* module Ext = Util.Uninhabited (* no extensions for now *) *)
module Ext = struct
  type t = Dup
    [@@deriving sexp, compare, hash]
end

module Hv = struct
  type t = string * int64
    [@@deriving sexp, compare, hash]
end

module T = Generic_ast.Make_netkat(Ext)(Hv)
include T

let as_netkat : (t, Hv.t) Netkat.t = (module T)
