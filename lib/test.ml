open Cleuros 
open Test_helper

(* let get_result progStr = *)
(*   let lexbuf = Lexing.from_string progStr in *)
(*   let prog = Parser.program Scanner.tokenize lexbuf in *)
(*   Cleuros.eval_program prog *)

let print_parsed progstr =
  let lexbuf = Lexing.from_string progstr in
  let prog = Parser.program Scanner.tokenize lexbuf in
  print_endline (Ast.string_of_prog prog)

let progstr_from_file path =
  let ch = open_in path in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let eval_test =
  (* let result = get_result "3\n" in
  test_int result 3;
  
  let result = get_result "x=13\nx\n" in
  test_int result 13;
  
  let result = get_result "xABC=13\nxABC\n" in
  test_int result 13;

  let result = get_result "#Comments only work as full lines\n#like so\n123\n" in
  test_int result 123;

  let result = get_result "x=1111 \n y=2222 \n exchange x with y \n y \n" in
  test_int result 1111; *)
  ()

let str_parsing_test _ = (* Add _ to stop it from printing *)
  (*print_parsed "x=1111 \n y=2222 \n exchange x with y \n y \n";
  print_parsed "{ \n x=1111 \n y=2222 \n}\n";

  print_parsed "if x + y\n {\n x = x + 1\n y = 2*y\n}\n else x=3\n";

  print_parsed "while x + y\n x = x + 1\n";

  print_parsed "while x + y\n {\n if x + y\n {\n x = x + 1\n y = 2*y\n}\n else x=3\n}\n";

  print_parsed "x < y\n y is less than z\n a > b \n b is greater than c\n";

  print_parsed "a + TEST-FUNCTION(x+y,z)\n return a\n";*)
  
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
    print_parsed s;
  )

