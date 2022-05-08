IR generation
=============
 - swap.cl: simple swapping
 - add.cl: binary operations
 - simple_func.cl: function calls
 - cond.cl: if statement

The above do not have main functions. You should handwrite a main function in IR
gen and call them manually. To call X:

let x_func = StringMap.find "X" function_decls
let x_res = L.build_call (fst x_func) [|x_args|] "x_res" builder in

