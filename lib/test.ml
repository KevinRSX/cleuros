open Cleuros 
open Test_helper

let get_result prog = 
  let lexbuf = Lexing.from_string prog in 
  let expr = Parser.program Scanner.tokenize lexbuf in 
  Cleuros.eval_program expr 

let _ = 
  let result = get_result "3\n" in
  test_int result 3;
  
  let result = get_result "x=13\nx\n" in
  test_int result 13;
  
  let result = get_result "xABC=13\nxABC\n" in
  test_int result 13;

  let result = get_result "#Comments only work as full lines\n#like so\n123\n" in
  test_int result 123;
