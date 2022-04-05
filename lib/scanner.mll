{ open Parser }

let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let letter = lower | upper

rule tokenize = parse
  [' ' '\t' '\r' '\n'] { tokenize lexbuf }
(* separators. TODO: GTE, LTE *)
(*Math*)
| '+'  { PLUS }
| '-'  { MINUS }
| '*'  { TIMES }
| '/'  { DIVIDE }
| '%'  { MOD }
(*Assignment*)
| ":=" { ASNTO }
(*Comparison*)
| '<'  { LESS }
| '>'  { GREATER }
| '='  { ISEQUALTO }
(*Punctuation*)
| ';'  { SEMI }
| '('  { LPAREN }
| ')'  { RPAREN }
| '{'  { LBRACE }
| '}'  { RBRACE }
| ','  { COMMA }
(*Comment*)
| '#'  { comment lexbuf }
(*Built-in functions*)
| "print"     { PRINT }
| "exchange"  { EXCHANGE }
| "with"      { WITH }
| "be"        { BE }
(*Control flow*)
| "if"        { IF }
| "else"      { ELSE }
| "while"     { WHILE }
| "return"    { RETURN }
(* types. TODO: char, string, array, custom type *)
| "int"       { INT }
| "bool"      { BOOL }
(* literals TODO: char literal, string literal, list *)
| "TRUE"      { BOOLVAR(true) }
| "FALSE"     { BOOLVAR(false) }
| digit+ as lit { LITERAL(int_of_string lit) }
(*Variables*)
| lower(letter | digit | '_')* as id { VARIABLE(id) }
(*Functions*)
| upper(upper | '-')+ as func { FUNCTION(func) }
| eof { EOF }
| _ as unchar { raise (Failure("Scanner error - Unknown character: " ^ Char.escaped unchar))}

and comment = parse 
  '\n' { tokenize lexbuf }
| _    { comment lexbuf}
