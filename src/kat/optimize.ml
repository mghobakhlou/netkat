open Base
open Ast

let ctrue = True
let cfalse = False

let skip = Assert ctrue
let abort = Assert cfalse


let conj b1 b2 =
  match b1, b2 with
  | (False as b), _ | _, (False as b)
  | True, b | b, True ->
    b
  | _, _ ->
    if phys_equal b1 b2 then b1 else
    Conj (b1, b2)

let disj b1 b2 =
  match b1, b2 with
  | (True as b), _ | _, (True as b)
  | False, b | b, False ->
    b
  | _, _ ->
    if phys_equal b1 b2 then b1 else
    Disj (b1, b2)

let neg b =
  match b with
  | True -> cfalse
  | False -> ctrue
  | Neg b -> b
  | _ -> Neg b


let assrt b = Assert b

let union e1 e2 =
  match e1, e2 with
  | Assert False, b | b, Assert False ->
    b
  | _, _ ->
    if phys_equal e1 e2 then e1 else
    Union (e1, e2)

let seq e1 e2 =
  match e1, e2 with
  | (Assert False as e), _ | _, (Assert False as e)
  | Assert True, e | e, Assert True ->
    e
  | _, _ ->
    Seq (e1, e2)

let star e =
  match e with
  | Assert _ -> skip
  | Star _ -> e
  | _ -> Star e

let ite b e1 e2 =
  union (seq (assrt b) e1) (seq (assrt (neg b)) e2)


let optimize_bexp ?(negate=false) b =
  let rec opt neg = function
    | True -> if neg then cfalse else ctrue
    | False -> if neg then ctrue else cfalse
    | Test _ as b -> if neg then (Neg b) else b
    | Conj (b1, b2) -> conj (opt neg b1) (opt neg b2)
    | Disj (b1, b2) -> disj (opt neg b1) (opt neg b2)
    | Neg b -> opt (not neg) b
  in
  opt negate b

let rec optimize_exp e =
  match e with
  | Assert b -> assrt (optimize_bexp b)
  | Action _ -> e
  | Union (e1, e2) -> union (optimize_exp e1) (optimize_exp e2)
  | Seq (e1, e2) -> seq (optimize_exp e1) (optimize_exp e2)
  | Star e -> star (optimize_exp e)


let rec bexp2_to_bexpn (b : 'test bexp) : 'test Nary.bexp =
  match b with
  | True -> Conj []
  | False -> Disj []
  | Test t -> Test t
  | Conj (b1, b2) -> Conj [bexp2_to_bexpn b1; bexp2_to_bexpn b2]
  | Disj (b1, b2) -> Disj [bexp2_to_bexpn b1; bexp2_to_bexpn b2]
  | Neg b -> Neg (bexp2_to_bexpn b)

let rec exp2_to_expn (e : ('act,'test) exp) : ('act,'test) Nary.exp =
  match e with
  | Assert b -> Assert (bexp2_to_bexpn b)
  | Action a -> Action a
  | Union (e1, e2) ->
    begin match exp2_to_expn e1, exp2_to_expn e2 with
    | Assert b1, Assert b2 ->
      Assert (Disj [b1;b2])
    | Assert b1, Union (Assert b2 :: es) ->
      Union (Assert (Disj [b1;b2]) :: es)
    | Union _, _ ->
      invalid_arg "union: not right-associative!"
    | e1, Union es -> Union (e1::es)
    | e1, e2 -> Union [e1; e2]
    end
  | Seq (e1, e2) ->
    begin match exp2_to_expn e1, exp2_to_expn e2 with
    | Assert b1, Assert b2 ->
      Assert (Conj [b1;b2])
    | Assert b1, Seq (Assert b2 :: es) ->
      Seq (Assert (Conj [b1;b2]) :: es)
    | Seq _, _ ->
      invalid_arg "seq: not right-associative!"
    | e1, Seq es -> Seq (e1::es)
    | e1, e2 -> Seq [e1; e2]
    end
  | Star e -> Star (exp2_to_expn e)


let rec bexpn_to_bexp2 (b : 'test Nary.bexp) : 'test bexp =
  match b with
  | Test t -> Test t
  | Conj bs ->
    List.fold bs ~init:ctrue ~f:(fun c b -> conj c (bexpn_to_bexp2 b))
  | Disj bs ->
    List.fold bs ~init:cfalse ~f:(fun c b -> disj c (bexpn_to_bexp2 b))
  | Neg b -> neg (bexpn_to_bexp2 b)

let rec expn_to_exp2 (e : ('act, 'test) Nary.exp) : ('act, 'test) exp =
  match e with
  | Assert b -> assrt (bexpn_to_bexp2 b)
  | Action a -> Action a
  | Union es ->
    List.fold es ~init:abort ~f:(fun f e -> union f (expn_to_exp2 e))
  | Seq es ->
    List.fold es ~init:skip ~f:(fun f e -> seq f (expn_to_exp2 e))
  | Star e -> star (expn_to_exp2 e)

let normalize_rassoc_exp e =
  expn_to_exp2 (exp2_to_expn e)