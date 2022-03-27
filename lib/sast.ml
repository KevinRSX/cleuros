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

(* Pretty-printing functions *)
let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
    SBinop(e1, b, e2) -> string_of_sexpr e1 ^ string_of_bop b ^ string_of_sexpr e2
  | SBLit(true) -> "true"
  | SBLit(false) -> "false"
  | SLit(l) -> string_of_int l
  | SAsn(id, e) -> id ^ " = " ^ string_of_sexpr e
  | SVar(id) -> id
  | SSwap(id1, id2) -> "swap(" ^ id1 ^ ", " ^ id2 ^ ")"
  | SCall(func, args) -> func ^ "(" ^ String.concat ", " (List.map string_of_sexpr args) ^ ")"
  ) ^ ")"
let rec string_of_sstmt = function
  | SExpr(e) -> string_of_sexpr e ^ "[;]\n"
  | Block(sstmts) -> "{\n" ^ String.concat "" (List.map string_of_sstmt sstmts) ^ "}\n"
  | If(cond, sstmt1, stmt2) ->
      "if " ^ string_of_sexpr cond ^ "\n" ^ string_of_sstmt sstmt1 ^ "else\n" ^
      string_of_sstmt sstmt2 (* TODO: change If & While to sstmt list *)
  | While(cond, sstmt) -> "while " ^ string_of_sexpr cond ^ "\n" ^ string_of_sstmt sstmt
  | Return(e) -> "return " ^ string_of_sexpr e ^ "[;]\n"

let string_of_sfdecl sfdecl =
  string_of_typ sfdecl.srtyp ^ " function:\n" ^
  fdecl.sfname ^ "(" ^ (String.concat ", " fdecl.sargs) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "}\n"

let string_of_sprogram prog =
  "\n\nSementically checked program: \n\n" ^
  String.concat "\n" (List.map string_of_sfdecl prog)
