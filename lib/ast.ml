type intop = Add | Sub | Mul | Div | Mod
type boolop =  Neq | Less | And | Or | Eq | Greater
type bop = Add | Sub | Mul | Div | Mod | Neq | Less | And | Or | Eq | Greater

type typ = Int | Float | Bool | Void | Temp (* No Char/String support now *)

type expr =
    Binop of expr * bop * expr
  | BLit of bool
  | ILit of int
  | FLit of float
  | Asn of string * expr
  | Var of string
  | Swap of string * string
  | Call of string * expr list 

type stmt = 
    Block of stmt list 
  | Expr of expr 
  | If of expr * stmt * stmt  
  | While of expr * stmt
  | For of string * int * int * stmt  (*id, lo, hi, stmt*)
  | Return of expr

type param_type = typ * string

type func_def = { 
    rtyp : typ;
    fname : string; 
    args : param_type list;
    body : stmt list;
}

type custom_type_def = {
  name: string; 
  vars: param_type list;
}

type prog_part = FuncDef of func_def | CustomTypeDef of custom_type_def

type program = prog_part list


let string_of_bop = function
    Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Eq -> "="
  | Neq -> "!="
  | Less -> "<"
  | And -> "&&"
  | Or -> "||"
  | Greater -> ">"

let rec string_of_expr = function 
    Binop(e1, b, e2) -> string_of_expr e1 ^ string_of_bop b ^ string_of_expr e2
  | BLit(true) -> "true"
  | BLit(false) -> "false"
  | ILit(l) -> string_of_int l 
  | FLit(l) -> string_of_float l
  | Asn(id, e) -> id ^ " = " ^ string_of_expr e 
  | Var(id) -> id 
  | Swap(id1, id2) -> "swap(" ^ id1 ^ ", " ^ id2 ^ ")"
  | Call(func, args) -> func ^ "(" ^ String.concat ", " (List.map string_of_expr args) ^ ")"

let rec string_of_stmt = function 
  | Expr(e) -> string_of_expr e ^ "[;]\n"
  | Block(stmts) -> "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | If(cond, stmt1, stmt2) -> "if " ^ string_of_expr cond ^ "\n" ^ string_of_stmt stmt1 ^ "else\n" ^ string_of_stmt stmt2
  | While(cond, stmt) -> "while " ^ string_of_expr cond ^ "\n" ^ string_of_stmt stmt
  | Return(e) -> "return " ^ string_of_expr e ^ "[;]\n"
  | For(id, lo, hi, stmt) -> "for " ^ id ^ "= " ^ (string_of_int lo) ^ " to " ^ (string_of_int hi) ^ (string_of_stmt stmt)

let string_of_typ = function
    Int -> "int"
  | Float -> "float"
  | Bool -> "bool"
  | Void -> "void"
  | Temp -> "Temp"

let string_of_param_type = function
  | (typ, param) -> "Param # (" ^ string_of_typ typ ^ ": " ^ param ^ ")"

let string_of_func_def fdecl = 
  string_of_typ fdecl.rtyp ^ " function:\n" ^
  fdecl.fname ^ "(" ^ (String.concat ", " (List.map string_of_param_type fdecl.args)) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_cust_type_def c = 
 c.name ^ " {" ^ (String.concat ", " (List.map string_of_param_type c.vars)) ^ "}"

let string_of_prog_part = function 
  | FuncDef(func_def) -> string_of_func_def func_def
  | CustomTypeDef(cust_type_def) -> string_of_cust_type_def cust_type_def

let string_of_prog prog = 
  "\n\nParsed program: \n\n" ^ (String.concat "\n" (List.map string_of_prog_part prog))
