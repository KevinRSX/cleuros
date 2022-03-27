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

type sstmt =
    SBlock of sstmt list 
  | SExpr of sexpr 
  | SIf of sexpr * sstmt * sstmt  
  | SWhile of sexpr * sstmt
  | SReturn of sexpr

type sfunc_def = { 
    srtyp : typ;
    sfname : string; 
    sargs : string list; 
    sbody : sstmt list;
}

type sprogram = sfunc_def list
