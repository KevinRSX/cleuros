open Ast
open Sast

let f_sym_table = Hashtbl.create 64 (* map of "{func}#{var}" -> type *)

let make_key fn id = fn ^ "#" ^ id

let set fn id typ = 
  let key = make_key fn id in 
  Hashtbl.add f_sym_table key typ 

let get fn id = 
  let key = make_key fn id in 
  try Hashtbl.find f_sym_table key 
  with Not_found -> raise (Failure ("undeclared identifier " ^ key))

let rec check_func_list all_func = 

  let rec check_expr cfunc = function
  | Binop (expr1, bop, expr2) -> (Temp, SBinop (check_expr cfunc expr1, bop,
    check_expr cfunc expr2))
  | BLit b -> (Bool, SBLit b)
  | Lit i -> (Int, SLit i)
  | Asn (id, expr) -> let typ, v = check_expr cfunc expr in 
     print_endline ("Asn " ^ make_key cfunc id ); set cfunc id typ; (Void, SAsn (id, (typ, v)))
  | Var id -> print_endline ("Var " ^ make_key cfunc id); (get cfunc id, SVar id)
  | Swap (id1, id2) -> (Void, SSwap (id1, id2))
  | Call (fname, arg_list) -> (Temp, SCall(fname, List.map (check_expr cfunc) arg_list))
  in

  let rec check_stmt_list cfunc all_stmt =
    let rec check_stmt cfunc = function
      | Block sub_stmts -> SBlock (check_stmt_list cfunc sub_stmts)
      | Expr expr -> SExpr (check_expr cfunc expr)
      (* TODO: probably add boolean support for condition of if *)
      | If (expr, stmt1, stmt2) -> SIf (check_expr cfunc expr, check_stmt cfunc stmt1,
        check_stmt cfunc stmt2)
      | While (expr, stmt) -> SWhile (check_expr cfunc expr, check_stmt cfunc stmt)
      | Return expr -> SReturn (check_expr cfunc expr)
    in
    match all_stmt with
    | [] -> []
    | s::sl -> check_stmt cfunc s :: check_stmt_list cfunc sl
  in

  let check_func func =
    {
      srtyp = func.rtyp;
      sfname = func.fname;
      sargs = func.args;
      sbody = check_stmt_list func.fname func.body;
    }
  in
  match all_func with
  | [] -> []
  | f::fl -> check_func f :: check_func_list fl
