IR generation
=============
 - swap.cl: simple swapping
 - binops.cl: binary operations
 - simple_func.cl: function calls
 - cond[_no_else].cl: if statement
 - while.cl: while statement
 - if_while.cl : while statement containing if-else
 - gcd_no_main.cl: GCD function without main
 - print.cl: print

The above do not have main functions. You should handwrite a main function in IR
gen and call them manually. To call X:

let x_func = StringMap.find "X" function_decls
let x_res = L.build_call (fst x_func) [|x_args|] "x_res" builder in

A reference BAR() -> FOO() function is provided in earlier commits. Check them
out if you need.

The following tests HAVE main function:
 - gcd.cl: The standard GCD function
