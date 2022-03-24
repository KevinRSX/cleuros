open Cleuros 
open Test_helper

(* let get_result progStr = *) 
(*   let lexbuf = Lexing.from_string progStr in *) 
(*   let prog = Parser.program Scanner.tokenize lexbuf in *) 
(*   Cleuros.eval_program prog *) 

let print_parse progStr = 
  let lexbuf = Lexing.from_string progStr in 
  let prog = Parser.program Scanner.tokenize lexbuf in 
  print_endline (Ast.string_of_prog prog)

let _ = 
  (* let result = get_result "3\n" in *)
  (* test_int result 3; *)
  
  (* let result = get_result "x=13\nx\n" in *)
  (* test_int result 13; *)
  
  (* let result = get_result "xABC=13\nxABC\n" in *)
  (* test_int result 13; *)

  (* let result = get_result "#Comments only work as full lines\n#like so\n123\n" in *)
  (* test_int result 123; *)

  (* let result = get_result "x=1111 \n y=2222 \n exchange x with y \n y \n" in *) 
  (* test_int result 1111; *)

  print_parse "x=1111 \n y=2222 \n exchange x with y \n y \n";