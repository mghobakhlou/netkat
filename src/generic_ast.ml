(** Untyped NetKAT AST *)

open Base

module T = struct 
  type ('ext, 'hv) pol =
    | Ext of 'ext           (** leave room for extensions (such as dup) *)
    | Filter of 'hv pred
    | Modify of 'hv
    | Union of ('ext, 'hv) pol * ('ext, 'hv) pol
    | Seq of ('ext, 'hv) pol * ('ext, 'hv) pol
    | Star of ('ext, 'hv) pol
  and 'hv pred =
    | Tru
    | Fls
    | Test of 'hv
    | Neg of 'hv pred
    | Conj of 'hv pred * 'hv pred
    | Disj of 'hv pred * 'hv pred
    [@@deriving sexp, compare, hash]

  let tru = Tru
  let fls = Fls
  let test hv = Test hv
  let conj b c = Conj (b,c)
  let disj b c = Disj (b,c)
  let neg b = Neg b

  let filter b = Filter b
  let modify hv = Modify hv
  let union p q = Union (p,q)
  let seq p q = Seq (p,q)
  let star p = Star p
end
include T


(** unique homomorphism from initial algebra (ASTs) into any NetKAT model  *)
let hom (type carrier) (type hv) (type ext)
  ~(target : (carrier, hv) Netkat.t)
  ~(interp_ext : ext -> carrier)
  : (ext, hv) pol 
  -> carrier 
  =
  let module Model = (val target) in
  let rec interp_pol =
    function
    | Ext ext -> interp_ext ext
    | Filter b -> Model.filter (interp_pred b)
    | Modify hv -> Model.modify hv
    | Union (p, q) -> Model.union (interp_pol p) (interp_pol q)
    | Seq (p, q) -> Model.seq (interp_pol p) (interp_pol q)
    | Star p -> Model.star (interp_pol p)
  and interp_pred = 
    function
    | Tru -> Model.tru
    | Fls -> Model.fls
    | Test hv -> Model.test hv
    | Neg b -> Model.neg (interp_pred b)
    | Conj (b, c) -> Model.conj (interp_pred b) (interp_pred c)
    | Disj (b, c) -> Model.disj (interp_pred b) (interp_pred c)
  in
  interp_pol


module M (Ext : Sig.T) (Hv : Sig.T) = struct
  type t = (Ext.t, Hv.t) pol [@@deriving sexp, compare, hash]
  type b = Hv.t pred [@@deriving sexp, compare, hash]
  type hv  = Hv.t [@@deriving sexp, compare, hash]
end

module Make_monomorph (Ext : Sig.T) (Hv : Sig.T) : Netkat.S with
  type t = (Ext.t, Hv.t) pol and
  type b = Hv.t pred and
  type hv = Hv.t
= struct
  include M(Ext)(Hv)
  include T
end
