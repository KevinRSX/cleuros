open Cleuros_parser 

let () = 
  let lexbuf = Lexing.from_channel stdin in
  let expr = Lexer.tokenize lexbuf in
  let result = Cleuros.eval expr in 
  print_endline (string_of_int result)

