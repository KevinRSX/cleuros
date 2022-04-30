let int_fmt = format_of_string "Expected: %d; Actual: %d"

let test_int (actual : int) (expected : int) = 
  (if actual = expected then print_endline "MATCH" else print_endline (Printf.sprintf int_fmt expected actual))

let print_parsed progstr =
  let lexbuf = Lexing.from_string progstr in
  let prog = Parser.program Scanner.next_token lexbuf in
  print_endline (Ast.string_of_prog prog)

let get_ast progstr =
  let lexbuf = Lexing.from_string progstr in
  Parser.program Scanner.next_token lexbuf

let progstr_from_file path =
  let ch = open_in path in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

