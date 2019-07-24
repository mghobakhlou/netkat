include Parsing.Make(struct
  type result = unit
  type token = Menhir_parser.token
  exception ParseError = Menhir_parser.Error
  let parse = Menhir_parser.ast_eof
  include Lexer
end)
