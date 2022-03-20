open Cleuros_parser

let () = 
  print_int (Cleuros.eval (Ast.Var "x")); print_newline (); 
  print_int (Cleuros.eval (Ast.Int 54)); print_newline ();
  print_int (Cleuros.eval (Ast.EOF)); print_newline();