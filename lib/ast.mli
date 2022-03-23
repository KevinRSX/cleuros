type operator = Add | Sub | Mul | Div

type expr =
    Binop of expr * operator * expr
  | Lit of int
  | Asn of string * expr
  | Var of string
  | Swap of string * string 

type program = expr list