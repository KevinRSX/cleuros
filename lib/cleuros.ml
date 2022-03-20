open Ast

let eval = function 
  Int(x) -> x 
| Var(_) -> 456
| EOF -> 123
