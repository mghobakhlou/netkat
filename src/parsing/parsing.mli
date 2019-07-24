module type PARSER = sig
  type token
  type result
  exception LexError of string
  exception ParseError
  (* val pp_token : Format.formatter -> token -> unit *)
  val parse : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> result
  val next_token : Lexing.lexbuf -> token
end

module type S = sig
  type token
  type result
  
  exception LexError of { msg: string; loc: Location.t }
  exception ParseError of { token: token; loc: Location.t }
  
  val parse_string : ?pos:Lexing.position -> string -> result
  val parse_chan : ?pos:Lexing.position -> in_channel -> result
  val parse_file : string -> result
  
  val pp_exceptions : unit -> unit
  (** Registers a pretty printer for lex and parse exceptions. This results in
      colorful error messages including the source location when errrors occur. *)
end

module Make : functor (P:PARSER) -> S with
  type token = P.token and
  type result = P.result