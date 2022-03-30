open Ast
open Sast

let f_sym_table = Hashtbl.create 64 (* map of "{func}#{var}" -> type *)
(* f_param_table stores types of the arguments. The function's type is stored
   in f_sym_table *)
let f_param_table = Hashtbl.create 64 

let make_key fn id = fn ^ "#" ^ id

(******* f_sym_table helpers *******)
let set key typ tbl = 
  let curr = Hashtbl.find_opt tbl key in 
  match curr with 
  | None -> Hashtbl.add tbl key typ 
  | Some curr_type -> if curr_type != typ then raise 
    (Failure ("identifier " ^ key ^ " has type " ^ string_of_typ curr_type ^
               " and is being set to " ^ string_of_typ typ))

let set_id fn id typ tbl =
  let key = make_key fn id in 
  set key typ tbl

let set_fn fn typ tbl =
  let key = make_key fn "" in 
  set key typ tbl

let get key tbl =
  try Hashtbl.find tbl key 
  with Not_found -> raise (Failure ("undeclared identifier " ^ key))

let get_id fn id tbl =
  let key = make_key fn id in 
  get key tbl 

let get_fn fn tbl =
  let key = make_key fn "" in
  get key tbl


(******* f_param_table helpers *******)
let verify_args fn arg_type_list tbl =
  let curr = Hashtbl.find_opt tbl fn in
  match curr with
  | None -> raise (Failure ("Undefined function call to " ^ fn))
  | Some param_type_list -> if param_type_list = arg_type_list then ignore ()
    else raise (Failure ("For function call to " ^ fn ^ ", arguments type (" ^ (String.concat ", "
    (List.map string_of_typ arg_type_list)) ^ ") don't match parameters (" ^
    (String.concat ", " (List.map string_of_typ param_type_list)) ^ ")"))

let set_func_param_table fn param_list tbl =
  let curr = Hashtbl.find_opt tbl fn in
  match curr with
  | None -> Hashtbl.add tbl fn param_list
  | Some _ -> raise (Failure ("Duplicated definition of function " ^ fn))


(****** Type checker entry point ******)
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
     set_id cfunc id typ f_sym_table; (Void, SAsn (id, (typ, v)))
  | Var id -> (get_id cfunc id f_sym_table, SVar id)
  | Swap (id1, id2) -> (Void, SSwap (id1, id2))
  | Call (fname, arg_list) ->
      let sarg_list = List.map (check_expr cfunc) arg_list in
      let arg_type_list = List.map (function (t, _) -> t) sarg_list in
      verify_args fname arg_type_list f_param_table;
      (* Prof. Edward said fst/snd was not functional and deducted my points for
         doing that in PFP *)
      (get_fn fname f_sym_table, SCall(fname, sarg_list))
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
  | f::fl -> 
      set_fn f.fname f.rtyp f_sym_table;
      let rec set_arg_ids = function
        | [] -> ignore ()
        | (typ, id) :: idl -> (set_id f.fname id typ f_sym_table); set_arg_ids
          idl in
      set_arg_ids f.args;
      set_func_param_table f.fname ((List.map (function (t, _) -> t) f.args))
                                      f_param_table;
      check_func f :: check_func_list fl
