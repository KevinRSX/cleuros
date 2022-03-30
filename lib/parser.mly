%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE MOD EQUAL EOF
%token SEMI LPAREN RPAREN COMMA PRINT EXCHANGE WITH BE
%token LBRACE RBRACE IF ELSE LESS WHILE GREATER
%token RETURN
%token INT BOOL
%token <bool> BOOLVAR
%token <int> LITERAL
%token <string> VARIABLE
%token <string> FUNCTION

%left SEMI
%right EQUAL

%left LESS GREATER
%left PLUS MINUS
%left TIMES DIVIDE MOD

%start program
%type <Ast.program> program

%%

program: fdecls EOF { $1 }
;

fdecls: 
/* nothing */ {[]}
| fdecl fdecls { $1 :: $2 }
;

typ:
| INT   { Int }
| BOOL  { Bool }

fdecl:
FUNCTION LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
{
    {
        rtyp = Void;
        fname = $1;
        args = $3;
        body = List.rev $6;
    }
}
| typ FUNCTION LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
{
    {
        rtyp = $1;
        fname = $2;
        args = $4;
        body = List.rev $7;
    }
}
;

/* function arguments */
formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }
;

formals_list:
  typ_binding { [$1] }
  | typ_binding COMMA formals_list { $1::$3 }
;

typ_binding:
  VARIABLE BE typ { ($3, $1) }
/* end function arguments */

stmt_list:
/* nothing */ { [] }
| stmt stmt_list { $1::$2 }
;


/* if-else are bound at this point */
stmt:
| expr SEMI { Expr($1) }
| LBRACE stmt_list RBRACE { Block($2) }
| IF expr stmt ELSE stmt { If($2, $3, $5) }
| WHILE expr stmt { While($2, $3) }
| RETURN expr SEMI { Return($2)}
;

expr:
| expr PLUS   expr    { Binop($1, Add, $3) }
| expr MINUS  expr    { Binop($1, Sub, $3) }
| expr TIMES  expr    { Binop($1, Mul, $3) }
| expr DIVIDE expr    { Binop($1, Div, $3) }
| expr MOD    expr    { Binop($1, Mod, $3) }
| expr LESS   expr    { Binop($1, Less, $3)}
| expr GREATER expr   { Binop($1, Greater, $3) }
| VARIABLE            { Var($1) }
| LITERAL             { Lit($1) }
| BOOLVAR             { BLit($1) }
| VARIABLE EQUAL expr { Asn($1, $3) }
| EXCHANGE VARIABLE WITH VARIABLE {Swap($2, $4)}
| FUNCTION LPAREN args_opt RPAREN { Call($1, $3)}
;

args_opt: 
/* nothing */ {[]}
| args { $1 }
;

args: 
 expr { [$1] }
| expr COMMA args { $1::$3 }
;
