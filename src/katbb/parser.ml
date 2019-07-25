include Parsing.Make(struct
  type result = Ast.exp
  type token = Menhir_parser.token
  exception ParseError = Menhir_parser.Error
  let parse = Menhir_parser.exp_eof
  include Lexer
end)
