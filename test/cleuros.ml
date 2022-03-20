open Cleuros_parser

let () = 
  print_int (Cleuros.eval (Var "x")); print_newline (); 
  print_int (Cleuros.eval (Int 54)); print_newline ();
  print_int (Cleuros.eval (EOF)); print_newline();