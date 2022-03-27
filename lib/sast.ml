open Ast

type sexpr = typ * sx
and sx = 
    SBinop of sexpr * bop * sexpr
  | SBLit of bool
  | SLit of int
  | SAsn of string * sexpr
  | SVar of string
  | SSwap of string * string
  | SCall of string * sexpr list 
