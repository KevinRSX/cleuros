let int_fmt = format_of_string "Expected: %d; Actual: %d"

let test_int (actual : int) (expected : int) = 
  (if actual = expected then print_endline "MATCH" else print_endline (Printf.sprintf int_fmt expected actual))

