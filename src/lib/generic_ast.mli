open Base

type ('ext, 'hv) pol =
  | Ext of 'ext           (** leave room for extensions *)
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

(** a function 'ext -> 'carrier extends uniquely to a homomorphism 
    ('ext, 'hv) pol -> ('carrier, 'hv) Netkat.t
*)
val hom : target:(('carrier, 'hv) Netkat.t)
       -> interp_ext:('ext -> 'carrier) 
       -> ('ext, 'hv) pol 
       -> 'carrier

val translate_hvs : f:('hv1 -> 'hv2) -> ('ext, 'hv1) pol -> ('ext, 'hv2) pol

module M : functor (Ext: Sig.T) -> functor (Hv: Sig.T) -> sig
  type t = (Ext.t, Hv.t) pol
  and b = Hv.t pred
  and hv = Hv.t
    [@@deriving sexp, compare, hash]
end

module Make_netkat : functor (Ext : Sig.T) -> functor (Hv : Sig.T) ->
  Netkat.S' with
    type t = (Ext.t, Hv.t) pol and
    type b = Hv.t pred and
    type hv = Hv.t
