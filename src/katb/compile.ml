open Idd_
open Ast
open Netkat_.Generic_ast


let rec compile_pred mgr label bexpr = 
  match bexpr with
  | Tru -> Bdd.ctrue
  | Fls -> Bdd.cfalse
  | Test { name; value } -> Bdd.test mgr (Var.inp (label name)) value
  | Neg b -> Bdd.neg mgr (compile_pred mgr label b)
  | Conj (e1, e2) -> 
      Bdd.conj mgr (compile_pred mgr label e1) (compile_pred mgr label e2)
  | Disj (e1, e2) -> 
      Bdd.disj mgr (compile_pred mgr label e1) (compile_pred mgr label e2)


let rec compile_pol (mgr:Idd.manager) label expr = 
  match expr with
  | Ext e -> failwith "Extensions not supported"
  | Filter b -> 
      let mgr_dd = Idd.get_manager_dd mgr in
      let bdd = compile_pred (Bdd.manager ~d_mgr:mgr_dd ()) label b in
      Idd.idd_from_dd mgr_dd (bdd :> Dd.t)
  | Modify { name; value } -> Idd.set mgr (label name) value
  | Union (e1, e2) -> 
      Idd.union mgr (compile_pol mgr label e1) (compile_pol mgr label e1)
  | Seq (e1, e2) -> 
      Idd.seq mgr (compile_pol mgr label e1) (compile_pol mgr label e1)
  | Star e -> Idd.star mgr (compile_pol mgr label e)

