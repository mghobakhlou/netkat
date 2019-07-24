%{
(* OCaml preamble *)
(* open Base *)
%}

(* tokens *)
%token LPAR RPAR EOF

%start <unit> ast_eof

%%

ast_eof:
  | ast; EOF { () }
  ;

ast:
  | nested+ { () }

nested:
  | LPAR; nested*; RPAR { () }
  ;

%%
