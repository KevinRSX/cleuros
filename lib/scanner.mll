{ open Parser }

let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let letter = lower | upper

rule tokenize = parse
  [' ' '\t' '\r' '\n'] { tokenize lexbuf }
(* separators *)
| ';'  { SEMI }
| '='  { EQUAL }
| '+'  { PLUS }
| '-'  { MINUS }
| '*'  { TIMES }
| '/'  { DIVIDE }
| '%'  { MOD }
| '('  { LPAREN }
| ')'  { RPAREN }
| '{'  { LBRACE }
| '}'  { RBRACE }
| ','  { COMMA }
| '<'  { LESS }
| '>'  { GREATER }
| '#'  { comment lexbuf }
(* reserved words. TODO: see LRM *)
| "print"     { PRINT }
| "exchange"  { EXCHANGE }
| "with"      { WITH }
| "if"        { IF }
| "else"      { ELSE }
| "while"     { WHILE }
| "return"    { RETURN }
| "be"        { BE }
(* types. TODO: char, string, array, custom type *)
| "int"       { INT }
| "bool"      { BOOL }
(* literals TODO: char literal, string literal, list *)
| "TRUE"      { BOOLVAR(true) }
| "FALSE"     { BOOLVAR(false) }
| digit+ as lit { LITERAL(int_of_string lit) }
| lower(letter | digit)* as id { VARIABLE(id) }
| upper(upper | '-')+ as func { FUNCTION(func) }
| eof { EOF }

and comment = parse 
  '\n' { tokenize lexbuf }
| _    { comment lexbuf}
