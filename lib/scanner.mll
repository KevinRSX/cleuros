{
  open Parser 

  let tab_counts = Stack.of_seq (Seq.return 0)
  let tokens = Queue.create () 

  let rec enqueue token n = 
    if n > 0 then (Queue.add token tokens; enqueue token (n-1))
}

let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let letter = lower | upper

rule tokenize = parse
  [' ' '\r' ] { tokenize lexbuf }
| ('\n')*('\t'* as tabs) {
  let num_tabs = String.length tabs in 
  let curr_tab_count = Stack.top tab_counts in
  if curr_tab_count > num_tabs then 
  (
    print_endline ((string_of_int num_tabs) ^ " " ^ (string_of_int curr_tab_count));
    enqueue DEDENT ((Stack.pop tab_counts) - num_tabs);
    print_endline ("DEDENT");
    Stack.push num_tabs tab_counts;
    print_endline ("NEWLINE");
    NEWLINE
  )
  else if curr_tab_count < num_tabs then 
  (
    print_endline ((string_of_int num_tabs) ^ " " ^ (string_of_int curr_tab_count));
    enqueue INDENT (num_tabs - curr_tab_count);
    print_endline ("INDENT");
    Stack.push num_tabs tab_counts; 
    print_endline ("NEWLINE");
    NEWLINE
  )
  else 
    (print_endline ("NEWLINE"); NEWLINE) 
}
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
| '('  { print_endline "LPAREN"; LPAREN }
| ')'  { print_endline "RPAREN"; RPAREN }
| '{'  { LBRACE }
| '}'  { RBRACE }
| ','  { COMMA }
| ':'  { print_endline "COLON";COLON }
(*Comment*)
| '#'  { comment lexbuf }
(*Built-in functions*)
| "print"     { PRINT }
| "exchange"  { EXCHANGE }
| "with"      { WITH }
| "be"        { BE }
(*Control flow*)
| "if"        { print_endline "IF";IF }
| "else"      { ELSE }
| "while"     { WHILE }
| "return"    { print_endline "RETURN";RETURN }
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
| upper(upper | '-')+ as func {
    print_endline func;
   FUNCTION(func) }
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