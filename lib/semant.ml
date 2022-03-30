open Ast
open Sast

let f_sym_table = Hashtbl.create 64 (* map of "{func}#{var}" -> type *)

let make_key fn id = fn ^ "#" ^ id

let set key typ = 
  let curr = Hashtbl.find_opt f_sym_table key in 
  match curr with 
  | None -> Hashtbl.add f_sym_table key typ 
  | Some curr_type -> if curr_type != typ then raise 
    (Failure ("identifier " ^ key ^ " has type " ^ string_of_typ curr_type ^
               " and is being set to " ^ string_of_typ typ))

let set_id fn id typ = 
  let key = make_key fn id in 
  set key typ

let set_fn fn typ = 
  let key = make_key fn "" in 
  set key typ

let get key = 
  try Hashtbl.find f_sym_table key 
  with Not_found -> raise (Failure ("undeclared identifier " ^ key))

let get_id fn id = 
  let key = make_key fn id in 
  get key 

let get_fn fn = 
  let key = make_key fn "" in
  get key


let rec check_func_list all_func = 
  
  (* cfunc == "containing function" *)
  let rec check_expr cfunc = function
  | Binop (e1, bop, e2) -> 
    let (t1, e1') as se1 = check_expr cfunc e1 in
    let (t2, e2') as se2 = check_expr cfunc e2 in 
    let err = "illegal binary op" in 
    if t1 = t2 then 
      let t = match bop with 
        Add | Sub | Mul | Div when t1 = Int -> Int 
      | Add | Sub | Mul | Div when t1 = Bool -> raise (Failure err)
      | Neq | Less | And | Or | Eq | Greater -> Bool
      | _ -> raise (Failure err) 
      in
      (t, SBinop(se1, bop, se2))
    else raise (Failure err)
  | BLit b -> (Bool, SBLit b)
  | Lit i -> (Int, SLit i)
  | Asn (id, expr) -> let typ, v = check_expr cfunc expr in 
     set_id cfunc id typ; (Void, SAsn (id, (typ, v)))
  | Var id -> (get_id cfunc id, SVar id)
  | Swap (id1, id2) -> (Void, SSwap (id1, id2))
  | Call (fname, arg_list) -> (get_fn fname, SCall(fname, List.map (check_expr cfunc) arg_list))
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
  | f::fl -> (set_fn f.fname f.rtyp); check_func f :: check_func_list fl
