let digit = ['0'-'9']
let lower = ['a'-'z']

rule tokenize = parse 
  [' ' '\t' '\r' '\n'] { tokenize lexbuf }
| digit+ as lit { Ast.Int(int_of_string lit) }
| lower+ as id { Ast.Var(id) }
| eof { EOF }