open Cleuros 
open Test_helper

let _ = 
  let lexbuf = Lexing.from_string "3\n" in 
  let expr = Parser.program Scanner.tokenize lexbuf in 
  let result = Cleuros.eval_program expr in
  test_int result 3;

  let lexbuf = Lexing.from_string "x=13\nx\n" in 
  let expr = Parser.program Scanner.tokenize lexbuf in 
  let result = Cleuros.eval_program expr in
  test_int result 13;


  let lexbuf = Lexing.from_string "xABC=13\nxABC\n" in 
  let expr = Parser.program Scanner.tokenize lexbuf in 
  let result = Cleuros.eval_program expr in
  test_int result 13;
