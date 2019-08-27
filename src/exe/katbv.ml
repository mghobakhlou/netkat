open Core
open Idds
open Katbv_lib

(*===========================================================================*)
(* UTILITY FUNCTIONS                                                         *)
(*===========================================================================*)

let parse_exp (exp : [`File of string | `String of string]) =
  match exp with
  | `File f -> Parser.parse_file f
  | `String s -> Parser.parse_string s

let compile_exp ?mgr (exp : Ast.exp) : Idd.t * int Hashtbl.M(String).t * Idd.manager =
  let mgr = match mgr with Some mgr -> mgr | None -> Idd.manager () in
  let tbl : int Hashtbl.M(String).t = Hashtbl.create (module String) in
  let next = ref (-1) in
  let map_var var =
    Hashtbl.find_or_add tbl var ~default:(fun () ->
      incr next;
      !next
    )
  in
  let idd = Compiler.to_idd ~mgr ~map_var exp in
  idd, tbl, mgr

let time f =
  let t1 = Unix.gettimeofday () in
  let r = f () in
  let t2 = Unix.gettimeofday () in
  (t2 -. t1, r)

let print_time ?(prefix="") time =
  printf "%scompilation time: %.4f\n" prefix time


(*===========================================================================*)
(* FLAGS                                                                     *)
(*===========================================================================*)

module Flag = struct
  open Command.Spec

  let stdin =
    flag "--stdin" no_arg
      ~doc:"Read expression from stdin instead of from file."
end


(*===========================================================================*)
(* COMMANDS                                                                  *)
(*===========================================================================*)

module Idd = struct
  let spec = Command.Spec.(
    empty
    +> anon ("file" %: string)
    +> Flag.stdin
  )

  let run file_or_str stdin () = begin
    Parser.pp_exceptions ();
    let exp =
      parse_exp (if stdin then `String file_or_str else `File file_or_str)
    in
    printf "parsing succeeded!\n";
    printf !"-> %{sexp:Ast.exp}\n" exp;

    let (time, (idd, map_var, _mgr)) = time (fun () -> compile_exp exp) in
    printf "%s\n" (Dd.to_string (idd :> Dd.t));
    print_time time;
    let var_name_tbl =
      Hashtbl.to_alist map_var
      |> List.map ~f:(fun (x,y) -> y,x)
      |> Hashtbl.of_alist_exn (module Int)
    in
    Dd.render (idd :> Dd.t) ~var_name:(fun var ->
      Format.sprintf "%s%s"
        (Hashtbl.find_exn var_name_tbl (Var.index var))
        (if Var.is_inp var then "?" else "!")
    );
  end

end


(*===========================================================================*)
(* BASIC SPECIFICATION OF COMMANDS                                           *)
(*===========================================================================*)

let idd : Command.t =
  Command.basic_spec
    ~summary:"Converts program to IDD and renders it."
    Idd.spec
    Idd.run

let main : Command.t =
  Command.group
    ~summary:"Analyzes KAT+BV program."
    [("idd", idd)]

let () =
  Command.run ~version: "0.1" ~build_info: "N/A" main
