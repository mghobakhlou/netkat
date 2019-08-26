open Base

(* [of_bexp_katbb bexp] is the Boolean KAT+B! expression representing [bexp]  *)
val to_bexp_katbb : Ast.bexp -> Katbb_lib.Ast.bexp

(* [of_exp_katbb exp] is the KAT+B! expression representing [exp] *)
val to_exp_katbb : Ast.exp -> Katbb_lib.Ast.exp

val to_bdd : Ast.bexp -> mgr:Idds.Bdd.manager -> map_var:(string -> int)
  -> Idds.Bdd.t

val to_idd : Ast.exp -> mgr:Idds.Idd.manager -> map_var:(string -> int)
  -> Idds.Idd.t

val to_table : Ast.exp -> Tables.t