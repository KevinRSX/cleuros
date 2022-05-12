{
  open Parser 

  let tab_counts = Stack.of_seq (Seq.return 0)
  let tokens = Queue.create () 

  let rec enqueue token n = 
    if n > 0 then (Queue.add token tokens; enqueue token (n-1))
}

let digit = ['0'-'9']
let fdigit = digit* '.' digit+ | digit+ '.' digit*
let exp = 'e' | 'E'
let lower = ['a'-'z']
let upper = ['A'-'Z']
let punctuation =  '-' | '_' | '.' | ',' | '!' | '&' | '*' | '+' | ':'
let letter = lower | upper

rule tokenize = parse
  [' ' '\r' ] { tokenize lexbuf }
| ('\n')*('\t'* as tabs) {
  let num_tabs = String.length tabs in 
  let curr_tab_count = Stack.top tab_counts in
  if curr_tab_count > num_tabs then 
  (
    (* print_endline ((string_of_int num_tabs) ^ " " ^ (string_of_int curr_tab_count)); *)
    enqueue DEDENT ((Stack.pop tab_counts) - num_tabs);
    Stack.push num_tabs tab_counts;
    NEWLINE
  )
  else if curr_tab_count < num_tabs then 
  (
    (* print_endline ((string_of_int num_tabs) ^ " " ^ (string_of_int curr_tab_count)); *)
    enqueue INDENT (num_tabs - curr_tab_count);
    Stack.push num_tabs tab_counts; 
    NEWLINE
  )
  else 
    (NEWLINE) 
}
(*Math*)
| '+'  { PLUS }
| '-'  { MINUS }
| '*'  { TIMES }
| '/'  { DIVIDE }
| '%'  { MOD }
(*Boolean Ops*)
| "and" { AND }
| "or"  { OR }
(*Assignment*)
| ":=" { ASNTO }
(*Comparison*)
| '<'  { LESS }
| '>'  { GREATER }
| '='  { ISEQUALTO }
| "!=" { NOTEQUAL }
(*Punctuation*)
| '('  { LPAREN }
| ')'  { RPAREN }
| '{'  { LBRACE }
| '}'  { RBRACE }
| ','  { COMMA }
| ':'  { COLON }
| '.'  { PERIOD }
| '['  { LBRACKET }
| ']'  { RBRACKET }
(*Comment*)
| '#'  { comment lexbuf }
(*Built-in functions*)
| "exchange"  { EXCHANGE }
| "with"      { WITH }
| "be"        { BE }
(*Control flow*)
| "if"        { IF }
| "else"      { ELSE }
| "while"     { WHILE }
| "for"       { FOR }
| "to"        { TO }
| "downto"    { DOWNTO }
| "return"    { RETURN }
(* types. TODO: char, string, array, custom type *)
| "int"       { INT }
| "bool"      { BOOL }
| "float"     { FLOAT }
(* literals TODO: char literal, string literal, list *)
| "TRUE"      { BOOLVAR(true) }
| "FALSE"     { BOOLVAR(false) }
| digit+ as lit { INTLITERAL(int_of_string lit) }
| fdigit as lit { FLOATLITERAL(float_of_string lit) }
| (fdigit | digit+) exp '-'? digit+ as lit { FLOATLITERAL(float_of_string lit) }
(*Custom Types*)
| "array"     { ARRAY }
| ".length"   { LENGTH }
| "newtype"   { NEWTYPE }
| upper(lower)+(letter)* as name { CUSTOMTYPENAME(name)}
| "let"       { LET }
| "be a"      { BEA }
(*Variables*)
| lower(letter | digit | '_')* as id { VARIABLE(id) }
(*Functions*)
| upper(upper | '-')+ as func {
    (* print_endline func; *)
   FUNCTION(String.lowercase_ascii func) }
(* Bug #4 *)
| '"' ((letter | punctuation | digit | ' ' | '\n')* as str_lit) '"'  {STRLITERAL(str_lit)}
| eof { EOF }
| _ as unchar { raise (Failure("Scanner error - Unknown character: " ^ Char.escaped unchar))}

and comment = parse 
  '\n' { tokenize lexbuf }
| _    { comment lexbuf}

{
let next_token lexbuf = 
	if Queue.is_empty tokens then 
    (
    tokenize lexbuf )
  else 
    (
    Queue.take tokens)
}
