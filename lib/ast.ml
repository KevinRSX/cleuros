type intop = Add | Sub | Mul | Div | Mod
type boolop =  Neq | Less | And | Or | Eq | Greater
type bop = Add | Sub | Mul | Div | Mod | Neq | Less | And | Or | Eq | Greater

type typ = Int | Float | Bool | String | Void | Temp | Array of typ(* No Char/String support now *)

type expr =
    Binop of expr * bop * expr
  | BLit of bool
  | ILit of int
  | FLit of float
  | StrLit of string
  | ArrayLit of expr list (* list of values [3,4,5] *)
  | Asn of string * expr
  | CustDecl of string * string 
  | Var of string
  | CustVar of string * string  (* id, var, e.g. myCustTypeVar.myIntVar *)
  | CustAsn of string * string * expr
  | ArrayDecl of string * int * typ (* name, size, type *)
  | ArrayAccess of string * expr (* name, loc should be int *)
  | ArrayMemberAsn of string * expr * expr (* name, loc, val *)
  | Swap of expr * expr (* ArrayAccess, ArrayAccess *)
  | Call of string * expr list 
  | ArrLength of string (* array to get the length of *)

type stmt = 
    Block of stmt list 
  | Expr of expr 
  | If of expr * stmt * stmt  
  | While of expr * stmt
  | For of string * expr * expr * stmt  (*id, lo, hi, stmt*)
  | Fordown of string * expr * expr * stmt (* id, hi, lo, stmt *)
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
  | Eq -> "=="
  | Neq -> "!="
  | Less -> "<"
  | And -> "&&"
  | Or -> "||"
  | Greater -> ">"

let rec string_of_typ = function
    Int -> "int"
  | Float -> "float"
  | Bool -> "bool"
  | Void -> "void"
  | Temp -> "Temp"
  | String -> "string"
  | Array typ -> "Array of " ^ (string_of_typ typ)

let enclose s around = around ^ s ^ around

let rec string_of_expr = function 
    Binop(e1, b, e2) -> string_of_expr e1 ^ string_of_bop b ^ string_of_expr e2
  | BLit(true) -> "true"
  | BLit(false) -> "false"
  | ILit(l) -> string_of_int l 
  | FLit(l) -> string_of_float l
  | ArrayLit(exprs) -> "[" ^ (String.concat ", " (List.map string_of_expr exprs)) ^ "]"
  | Asn(id, e) -> id ^ " := " ^ string_of_expr e 
  | Var(id) -> id 
  | Swap(e1, e2) -> "swap(" ^ (string_of_expr e1) ^ ", " ^
      (string_of_expr e2) ^ ")"
  | Call(func, args) -> func ^ "(" ^ String.concat ", " (List.map string_of_expr args) ^ ")"
  | CustDecl(id, cust_type) -> id ^ " is " ^ cust_type
  | CustAsn(id, var, e) -> id ^ "." ^ var ^ " := " ^ string_of_expr e
  | CustVar(id, var) -> id ^ "." ^ var 
  | ArrayDecl(id, size, t) -> "Array: " ^ id ^ " of type " ^ (string_of_typ t) ^ " with size " ^ (string_of_int size)
  | ArrayAccess (id, loc) -> id ^ "[" ^ (string_of_expr loc) ^ "]"
  | ArrayMemberAsn (id, loc, v) -> id ^ "[" ^ (string_of_expr loc) ^ "]" ^ " := " ^ (string_of_expr v)
  | StrLit(str) -> enclose str "\""
  | ArrLength(id) -> id ^ ".length"

let rec string_of_stmt = function 
  | Expr(e) -> string_of_expr e ^ "[;]\n"
  | Block(stmts) -> "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | If(cond, stmt1, stmt2) -> "if " ^ string_of_expr cond ^ "\n" ^ string_of_stmt stmt1 ^ "else\n" ^ string_of_stmt stmt2
  | While(cond, stmt) -> "while " ^ string_of_expr cond ^ "\n" ^ string_of_stmt stmt
  | Return(e) -> "return " ^ string_of_expr e ^ "[;]\n"
  | For(id, lo, hi, stmt) ->
      "for " ^ id ^ "= " ^ (string_of_expr lo) ^ " to " ^
      (string_of_expr hi) ^ (string_of_stmt stmt)
  | Fordown (id, hi, lo, stmt) ->
      "for " ^ id ^ "= " ^ (string_of_expr hi) ^ " downto " ^
      (string_of_expr lo) ^ (string_of_stmt stmt)

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
