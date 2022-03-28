open Ast
open Sast

module StringMap = Map.Make(String)


let rec check_func_list all_func = 
  let check_func func =
    {
      srtyp = func.rtyp;
      sfname = func.fname;
      sargs = func.args;
      sbody = [];
    }
  in
  match all_func with
  | [] -> []
  | f::fl -> check_func f :: check_func_list fl

let check_program = check_func_list
