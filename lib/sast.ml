open Ast

type sexpr = typ * sx
and sx = 
    SBinop of sexpr * bop * sexpr
  | SBLit of bool
  | SLit of int
  | SAsn of string * sexpr (* must be Void reported by semant.ml *)
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
    sargs : param_type list;
    sbody : sstmt list;
}

type sprogram = sfunc_def list

(* Pretty-printing functions *)
let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
    SBinop(e1, b, e2) -> string_of_sexpr e1 ^ " " ^ string_of_bop b ^ " " ^
                          string_of_sexpr e2
  | SBLit(true) -> "TRUE"
  | SBLit(false) -> "FALSE"
  | SLit(l) -> string_of_int l
  | SAsn(id, e) -> "Assignment # " ^ id ^ " := " ^ string_of_sexpr e
  | SVar(id) -> id
  | SSwap(id1, id2) -> "swap(" ^ id1 ^ ", " ^ id2 ^ ")"
  | SCall(func, args) -> "Call # " ^ func ^ "(" ^ String.concat ", " (List.map string_of_sexpr args) ^ ")"
  ) ^ ")"

let rec string_of_sstmt = function
  | SExpr(e) -> string_of_sexpr e ^ "[;]\n"
  | SBlock(sstmts) -> "{\n" ^ String.concat "" (List.map string_of_sstmt (List.rev sstmts)) ^ "}\n"
  | SIf(cond, sstmt1, sstmt2) ->
      "if " ^ string_of_sexpr cond ^ "\n" ^ string_of_sstmt sstmt1 ^ "else\n" ^
      string_of_sstmt sstmt2
  | SWhile(cond, sstmt) -> "while " ^ string_of_sexpr cond ^ "\n" ^ string_of_sstmt sstmt
  | SReturn(e) -> "return " ^ string_of_sexpr e ^ "[;]\n"

let string_of_sfdecl sfdecl =
  string_of_typ sfdecl.srtyp ^ " function:\n" ^
  sfdecl.sfname ^ "(" ^ (String.concat ", " (List.map string_of_param_type sfdecl.sargs)) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_sstmt (List.rev sfdecl.sbody)) ^
  "}\n"

let string_of_sprogram prog =
  "\n\nSementically checked program: \n\n" ^
  String.concat "\n" (List.map string_of_sfdecl prog)
