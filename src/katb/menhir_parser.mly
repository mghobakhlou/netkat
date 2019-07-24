%{
%}

(* tokens *)
%token LPAR RPAR EOF
%token <string> VAR
%token BANG QMARK TILDE TICK
%token PLUS SCOLON STAR
(* %token TRUE FALSE SKIP ABORT *)
%token ZERO ONE
%token IF THEN ELSE

(* precedence and associativity - from lowest to highest *)
%nonassoc ELSE
%nonassoc low
%left PLUS
%left SCOLON
%nonassoc TILDE
%nonassoc STAR
(* %nonassoc BANG QMARK TICK *)

%start <Ast.exp> exp_eof
%start <Ast.bexp> bexp_eof

%%

exp_eof:
  | e=exp; EOF { e }
  ;

exp:
  | b=bexp { Kat.Optimize.assrt b }
    %prec low
  | var=VAR; has_tick=option(TICK); BANG
    { Kat.Ast.Action Ast.{ var; value = Option.is_none has_tick } }
  | e1=exp; PLUS; e2=exp
    { Kat.Optimize.union e1 e2 }
  | e1=exp; SCOLON; e2=exp
    { Kat.Optimize.seq e1 e2 }
  | e=exp; STAR
    { Kat.Ast.Star e }
  | IF; b=bexp; THEN; e1=exp; ELSE; e2=exp
    { Kat.Optimize.ite b e1 e2 }
  | LPAR; e=exp; RPAR { e }


bexp_eof:
  | b=bexp; EOF { b }
  ;

bexp:
  | ONE { Kat.Optimize.ctrue }
  | ZERO { Kat.Optimize.cfalse }
  | var=VAR; has_tick=option(TICK); QMARK
    { Kat.Ast.Test Ast.{ var; value = Option.is_none has_tick } }
  | b1=bexp; PLUS; b2=bexp
    { Kat.Optimize.disj b1 b2 }
  | b1=bexp; SCOLON; b2=bexp
    { Kat.Optimize.conj b1 b2 }
  | TILDE; b=bexp { Kat.Ast.Neg b }
  | LPAR; b=bexp; RPAR { b }

%%
