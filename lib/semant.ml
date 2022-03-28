open Ast
open Sast

module StringMap = Map.Make(String)

let check_funcs (all_func : func_def list) : string = "checked"
