(** Untyped NetKAT AST *)

open Base

type header = string
  [@@deriving sexp, compare, hash]
type value = Bits.t
  [@@deriving sexp, compare, hash]
type mask = Bits.t
  [@@deriving sexp, compare, hash]

type pred =
  | True
  | False
  | Test of header * value * mask
  | And of pred * pred
  | Or of pred * pred
  | Not of pred
  [@@deriving sexp, compare, hash]

type pol =
  | Match of pred
  | Modify of header * value * mask
  | Union of pol * pol
  | Seq of pol * pol
  | Star of pol
  | Dup
  [@@deriving sexp, compare, hash]
