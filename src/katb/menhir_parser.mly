%{
  open Base
%}

(* tokens *)
%token LPAR RPAR EOF
%token <string> VAR
%token BANG QMARK TILDE TICK
%token PLUS SCOLON STAR
(* %token TRUE FALSE SKIP ABORT *)
%token ZERO ONE

%start <Ast.bexp> bexp_eof
%start <Ast.exp> exp_eof

%%

exp_eof:
  | e=exp; EOF { e }
  ;

exp:
  | ONE { Kat.Optimize.skip }
  | ZERO { Kat.Optimize.abort }
  | b=bexp { Kat.Optimize.assrt b }

bexp_eof:
  | b=bexp; EOF { b }
  ;

bexp:
  | ONE { Kat.Optimize.ctrue }
  | ZERO { Kat.Optimize.cfalse }
  | var=VAR; has_tick=option(TICK); QMARK
    { Kat.Ast.Test Ast.{ var; value = Option.is_none has_tick } }

%%
