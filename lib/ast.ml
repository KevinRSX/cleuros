type bop = Add | Sub | Mul | Div | Neq | Less | And | Or | Eq

type expr =
    Binop of expr * bop * expr
  | BLit of bool
  | Lit of int
  | Asn of string * expr
  | Var of string
  | Swap of string * string 

type stmt = 
    Block of stmt list 
  | Expr of expr 
  | If of expr * stmt * stmt  
  | While of expr * stmt

type program = expr list

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

let rec string_of_expr = function 
    Binop(e1, b, e2) -> string_of_expr e1 ^ string_of_bop b ^ string_of_expr e2
  | BLit(true) -> "true"
  | BLit(false) -> "false"
  | Lit(l) -> string_of_int l 
  | Asn(id, e) -> id ^ " = " ^ string_of_expr e 
  | Var(id) -> id 
  | Swap(id1, id2) -> "swap(" ^ id1 ^ ", " ^ id2 ^ ")"

let rec string_of_stmt = function 
  | Expr(e) -> string_of_expr e ^ ";\n"
  | Block(stmts) -> "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | _ -> "\n"

let rec string_of_prog = function 
  | [] -> ""
  | hd :: tl -> string_of_expr hd ^ ";\n" ^ string_of_prog tl