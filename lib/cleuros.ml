open Test_helper
open Semant
open Irgen


let str_parsing_test _ = (* Add _ to stop it from printing *)
  print_endline "==========PARSING STRINGS TEST START==========";
  print_parsed "MAIN()\n{\n}\n";
  print_parsed "MAIN(x)\n{\n x = 5\n x=x+1\n return x\n}\n";
  print_endline "==========PARSING STRINGS TEST END==========";
  ()

let usage = "Usage: " ^ Sys.argv.(0) ^ " <input_file>"

let _ =
  if Array.length Sys.argv != 2 then (print_endline usage; exit (-1);)
  else
  (
    let s =  progstr_from_file Sys.argv.(1) in
    let ast = get_ast s in
    let sast = check_func_list ast in
    print_endline (L.string_of_llmodule (translate sast));
    (* print the SAST for front-end debugging purposes *)
    (* print_endline (Sast.string_of_sprogram (check_func_list ast)); *)

    (* print the untyped AST for front-end debugging purposes*)
    (* print_parsed s; *)
  )

