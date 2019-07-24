open Idds
open Kat.Hom


(** [get_ba mgr] produces an instance of [Bdd.t ba] given a BDD manager [mgr] *)
let get_ba mgr = {
    ctrue = Bdd.ctrue;
    cfalse = Bdd.cfalse;
    conj = Bdd.conj mgr;
    disj = Bdd.disj mgr;
    neg = Bdd.neg mgr;
  }

let get_kat mgr = {
    ba = get_ba (Idd.get_bdd_manager mgr);
    assrt = Idd.of_bdd;
    union = Idd.union mgr;
    seq = Idd.seq mgr;
    star = Idd.star mgr;
  }

(** [interp_test_mgr mgr interp_var test] is the BDD resulting from testing
    the variable specificed by [interp_var test.name] according to
    [test.value] *)
let interp_test_mgr mgr interp_var ({ var; value }: Ast.test) =
  Bdd.test mgr (Var.inp (interp_var var)) value

let compile_bexp ~mgr ~interp_var bexp =
  let ba = get_ba mgr in
  let interp_test = interp_test_mgr mgr interp_var in
  interp_bexp ~ba ~interp_test bexp

let compile_exp ~mgr ~interp_var exp =
  let kat = get_kat mgr in
  let bdd_mgr = Idd.get_bdd_manager mgr in
  let interp_test = interp_test_mgr bdd_mgr interp_var in
  let interp_act ({ var; value }: Ast.act) =
    Idd.set mgr (interp_var var) value
  in
  interp_exp ~kat ~interp_test ~interp_act exp
