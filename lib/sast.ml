open Ast

type sexpr = typ * sx
and sx = 
    SBinop of sexpr * bop * sexpr
  | SBLit of bool
  | SILit of int
  | SFLit of float
  | SAsn of string * sexpr (* must be Void reported by semant.ml *)
  | SCustAsn of string * string (* (id, custom_type) *)
  | SVar of string
  | SSwap of string * string
  | SCall of string * sexpr list 

type sstmt =
    SBlock of sstmt list 
  | SExpr of sexpr 
  | SIf of sexpr * sstmt * sstmt  
  | SWhile of sexpr * sstmt
  | SFor of string * int * int * sstmt
  | SReturn of sexpr

type sfunc_def = { 
    srtyp : typ;
    sfname : string; 
    sargs : param_type list;
    sbody : sstmt list;
}

type scustom_type_def = {
  sname: string; 
  svars: param_type list;
}

type sprog_part = SFuncDef of sfunc_def | SCustomTypeDef of scustom_type_def

type sprogram = sprog_part list

(* Pretty-printing functions *)
let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
    SBinop(e1, b, e2) -> string_of_sexpr e1 ^ " " ^ string_of_bop b ^ " " ^
                          string_of_sexpr e2
  | SBLit(true) -> "TRUE"
  | SBLit(false) -> "FALSE"
  | SILit(l) -> string_of_int l
  | SFLit(l) -> string_of_float l
  | SAsn(id, e) -> "Assignment # " ^ id ^ " := " ^ string_of_sexpr e
  | SCustAsn(id, cust) -> "CustomAssignment # " ^ id ^ " := " ^ cust
  | SVar(id) -> id
  | SSwap(id1, id2) -> "swap(" ^ id1 ^ ", " ^ id2 ^ ")"
  | SCall(func, args) -> "Call # " ^ func ^ "(" ^ String.concat ", " (List.map string_of_sexpr args) ^ ")"
  ) ^ ")"

let rec string_of_sstmt = function
  | SExpr(e) -> string_of_sexpr e ^ "[;]\n"
  | SBlock(sstmts) -> "{\n" ^ String.concat "" (List.map string_of_sstmt sstmts) ^ "}\n"
  | SIf(cond, sstmt1, sstmt2) ->
      "if " ^ string_of_sexpr cond ^ "\n" ^ string_of_sstmt sstmt1 ^ "else\n" ^
      string_of_sstmt sstmt2
  | SWhile(cond, sstmt) -> "while " ^ string_of_sexpr cond ^ "\n" ^ string_of_sstmt sstmt
  | SFor(id, lo, hi, sstmt) -> "for " ^ id ^ " = " ^ (string_of_int lo) ^ " to " ^ (string_of_int hi) ^ (string_of_sstmt sstmt)
  | SReturn(e) -> "return " ^ string_of_sexpr e ^ "[;]\n"

let string_of_sfdecl sfdecl =
  string_of_typ sfdecl.srtyp ^ " function:\n" ^
  sfdecl.sfname ^ "(" ^ (String.concat ", " (List.map string_of_param_type sfdecl.sargs)) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_sstmt sfdecl.sbody) ^
  "}\n"


let string_of_scust_type_def c = 
  c.sname ^ " {" ^ (String.concat ", " (List.map string_of_param_type c.svars)) ^ "}"
 
 let string_of_prog_part = function 
   | SFuncDef(sfunc_def) -> string_of_sfdecl sfunc_def
   | SCustomTypeDef(scust_type_def) -> string_of_scust_type_def scust_type_def
 

let string_of_sprogram prog =
  "\n\nSementically checked program: \n\n" ^
  String.concat "\n" (List.map string_of_prog_part prog)
