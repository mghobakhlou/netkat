open Idds


(** [compile_bexp mgr interp_var bexp] is the BDD representing [bexp] where
    [interp_var] maps test names to their respective DD variable indices.
    This mapping is required to be injective (or else the result is undefined).
*)
val compile_bexp : mgr:Bdd.manager -> interp_var:(string -> int)
  -> Ast.bexp -> Bdd.t

(** [compile_exp mgr interp_var exp] is the IDD representing [exp] where
    [interp_var] maps test names to their respective DD variable indices.
    This mapping is required to be injective (or else the result is undefined).
*)
val compile_exp : mgr:Idd.manager -> interp_var:(string -> int)
  -> Ast.exp -> Idd.t
