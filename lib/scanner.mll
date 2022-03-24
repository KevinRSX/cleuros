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
| '('  { LPAREN }
| ')'  { RPAREN }
| '{'  { LBRACE }
| '}'  { RBRACE }
| ','  { COMMA }
| '<'  { LESS }
| "is less than" { LESS }
| '>'  { GREATER }
| "is greater than" { GREATER }
| '#'  { comment lexbuf}
| "print" { PRINT }
| "exchange" { EXCHANGE }
| "with"  { WITH }
| "if"    { IF }
| "else"  { ELSE }
| "while" { WHILE }
| "return" { RETURN }
| digit+ as lit { LITERAL(int_of_string lit) }
| lower(letter | digit)* as id { VARIABLE(id) }
| upper+ as func { FUNCTION(func) }
| eof { EOF }


(* TODO: allow comments to start in the middle of a line *)
and comment = parse 
  '\n' { tokenize lexbuf }
| _    { comment lexbuf}
