{ open Parser }

let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let letter = lower | upper

rule tokenize = parse
  [' ' '\t' '\r'] { tokenize lexbuf }
| '\n' { NEWLINE }
| '='  { EQUAL }
| '+'  { PLUS }
| '-'  { MINUS }
| '*'  { TIMES }
| '/'  { DIVIDE }
| ';'  { SEMI }
| digit+ as lit { LITERAL(int_of_string lit) }
| lower(letter | digit)* as id { VARIABLE(id) }
| eof { EOF }
