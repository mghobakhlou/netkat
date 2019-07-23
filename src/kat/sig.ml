open Base

type 'b ba = {
  ctrue : 'b;
  cfalse : 'b;
  conj : 'b -> 'b -> 'b;
  disj : 'b -> 'b -> 'b;
  neg : 'b -> 'b;
}

type ('k, 'b) kat = {
  ba : 'b ba;
  assrt : 'b -> 'k;
  union : 'k -> 'k -> 'k;
  seq : 'k -> 'k -> 'k;
  star : 'k -> 'k;
}
