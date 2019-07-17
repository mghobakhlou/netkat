open Netkat_
open Util

type hv = { name: string; value: bool }
type expr = (Uninhabited.t, hv) Generic_ast.pol
type bexpr = hv Generic_ast.pred
