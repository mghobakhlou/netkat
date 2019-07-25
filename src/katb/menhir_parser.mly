%{
%}

(* tokens *)
%token LPAR RPAR EOF
%token <string> VAR
%token BANG QMARK TILDE BTICK
%token PLUS SCOLON STAR
(* %token TRUE FALSE SKIP ABORT *)
%token ZERO ONE
%token IF THEN ELSE

(* precedence and associativity - from lowest to highest *)
%nonassoc ELSE
%right PLUS
%right SCOLON
%nonassoc STAR

%start <Ast.exp> exp_eof
%start <Ast.bexp> bexp_eof

%%

exp_eof:
  | e=exp; EOF { e }
  ;

bexp_eof:
  | b=bexp; EOF { b }
  ;

exp:
  | e1=exp; PLUS; e2=exp
    { Kat.Optimize.union e1 e2 }
  | e1=exp; SCOLON; e2=exp
    { Kat.Optimize.seq e1 e2 }
  | e=exp; STAR
    { Kat.Ast.Star e }
  | var=VAR; has_tick=option(BTICK); BANG
    { Kat.Ast.Action Ast.{ var; value = Option.is_none has_tick } }
  | IF; b=bexp; THEN; e1=exp; ELSE; e2=exp { Kat.Optimize.ite b e1 e2 }
  | LPAR; e=exp; RPAR {e}
  | b=bexpRest { Kat.Optimize.assrt b }
  ;

bexp:
  | b1=bexp; PLUS; b2=bexp
    { Kat.Optimize.disj b1 b2 }
  | b1=bexp; SCOLON; b2=bexp
    { Kat.Optimize.conj b1 b2 }
  | b=bexpRest { b }
  ;

bexpRest:
  | ONE { Kat.Optimize.ctrue }
  | ZERO { Kat.Optimize.cfalse }
  | var=VAR; has_tick=option(BTICK); QMARK
    { Kat.Ast.Test Ast.{ var; value = Option.is_none has_tick } }
  | TILDE; b=bexpRest { Kat.Ast.Neg b }
  | TILDE; LPAR; b=bexp ; RPAR { Kat.Ast.Neg b }
  ;

%%
