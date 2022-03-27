type bop = Add | Sub | Mul | Div | Neq | Less | And | Or | Eq | Greater

type expr =
    Binop of expr * bop * expr
  | BLit of bool
  | Lit of int
  | Asn of string * expr
  | Var of string
  | Swap of string * string
  | Call of string * expr list 

type stmt = 
    Block of stmt list 
  | Expr of expr 
  | If of expr * stmt * stmt  
  | While of expr * stmt
  | Return of expr

type func_def = { 
    fname : string; 
    args : string list; 
    body : stmt list;
  }

type program = func_def list

let string_of_bop = function
    Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Eq -> "=="
  | Neq -> "!="
  | Less -> "<"
  | And -> "&&"
  | Or -> "||"
  | Greater -> ">"

let rec string_of_expr = function 
    Binop(e1, b, e2) -> string_of_expr e1 ^ string_of_bop b ^ string_of_expr e2
  | BLit(true) -> "true"
  | BLit(false) -> "false"
  | Lit(l) -> string_of_int l 
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

let string_of_func_def fdecl = 
  fdecl.fname ^ "(" ^ (String.concat ", " fdecl.args) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_prog prog = 
  "\n\nParsed program: \n\n" ^ String.concat "\n" (List.map string_of_func_def prog)
