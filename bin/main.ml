open Cleuros_parser 

let _ = 
  let result = Cleuros.eval (Var "x") in 
  print_endline (string_of_int result)

