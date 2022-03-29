open Ast
open Sast

module StringMap = Map.Make(String)

let rec check_expr = function
  | Lit i -> (Int, SLit i)
  | Asn (id, expr) -> (Void, SAsn (id, check_expr expr))
  | Var (id) -> (Temp, SVar id)
  | Swap (id1, id2) -> (Void, SSwap (id1, id2))
  | Call (fname, arg_list) -> (Temp, SCall(fname, List.map check_expr arg_list))
  | _ -> (Int, SLit 1000)


let rec check_stmt_list all_stmt =
  let rec check_stmt = function
    | Block sub_stmts -> SBlock (check_stmt_list sub_stmts)
    | Expr expr -> SExpr (check_expr expr)
    (* TODO: probably add boolean support for condition of if *)
    | If (expr, stmt1, stmt2) -> SIf (check_expr expr, check_stmt stmt1,
      check_stmt stmt2)
    | While (expr, stmt) -> SWhile (check_expr expr, check_stmt stmt)
    | Return expr -> SReturn (check_expr expr)
  in
  match all_stmt with
  | [] -> []
  | s::sl -> check_stmt s :: check_stmt_list sl


let rec check_func_list all_func = 
  let check_func func =
    {
      srtyp = func.rtyp;
      sfname = func.fname;
      sargs = func.args;
      sbody = check_stmt_list func.body;
    }
  in
  match all_func with
  | [] -> []
  | f::fl -> check_func f :: check_func_list fl

let check_program = check_func_list
