open Idds


(** [compile_bexp mgr interp_fields bexp] is the BDD representing [bexp] where
    [interp_fields] maps test names to their respective DD variable indices.
    This mapping is required to be injective (or else the result is undefined).
*)
val compile_bexp : Bdd.manager -> interp_fields:(string -> int)
  -> Ast.bexp -> Bdd.t

(** [compile_exp mgr interp_fields exp] is the IDD representing [exp] where
    [interp_fields] maps test names to their respective DD variable indices.
    This mapping is required to be injective (or else the result is undefined).
*)
val compile_exp : Idd.manager -> interp_fields:(string -> int)
  -> Ast.exp -> Idd.t
