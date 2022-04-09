%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE MOD ISEQUALTO ASNTO EOF
%token SEMI LPAREN RPAREN COMMA PRINT EXCHANGE WITH BE
%token LBRACE RBRACE IF ELSE LESS WHILE GREATER
%token INDENT DEDENT COLON NEWLINE
%token RETURN
%token INT BOOL
%token <bool> BOOLVAR
%token <int> LITERAL
%token <string> VARIABLE
%token <string> FUNCTION

%left SEMI
%right ASNTO

%left LESS GREATER ISEQUALTO
%left PLUS MINUS
%left TIMES DIVIDE MOD

%start program
%type <Ast.program> program

%%

program: fdecls EOF { $1 }
;

fdecls: 
/* nothing */ {[]}
| fdecls fdecl  { $2::$1 }
;

typ:
| INT   { Int }
| BOOL  { Bool }

fdecl:
FUNCTION LPAREN formals_opt RPAREN COLON NEWLINE INDENT stmt_list DEDENT
{
    {
        rtyp = Void;
        fname = $1;
        args = $3;
        body = $8;
    }
}
| typ FUNCTION LPAREN formals_opt RPAREN COLON NEWLINE INDENT stmt_list DEDENT
{
    {
        rtyp = $1;
        fname = $2;
        args = $4;
        body = $9;
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
| stmt_list stmt  { $2::$1 }
;


/* if-else are bound at this point */
stmt:
| expr NEWLINE { Expr($1) }
| IF expr COLON NEWLINE INDENT stmt_list DEDENT { If($2, Block $6, Block []) }
| IF expr COLON NEWLINE INDENT stmt_list DEDENT ELSE COLON NEWLINE INDENT stmt_list DEDENT { If($2, Block $6, Block $12) }
| WHILE expr COLON NEWLINE INDENT stmt_list DEDENT { While($2, Block ($6)) }
| RETURN expr NEWLINE { Return($2)}
;

expr:
/* arithmetic */
| expr PLUS   expr    { Binop($1, Add, $3) }
| expr MINUS  expr    { Binop($1, Sub, $3) }
| expr TIMES  expr    { Binop($1, Mul, $3) }
| expr DIVIDE expr    { Binop($1, Div, $3) }
| expr MOD    expr    { Binop($1, Mod, $3) }
/* logical */
| expr LESS     expr  { Binop($1, Less, $3) }
| expr GREATER  expr  { Binop($1, Greater, $3) }
| expr ISEQUALTO    expr  { Binop($1, Eq, $3) }
| VARIABLE            { Var($1) }
| LITERAL             { Lit($1) }
| BOOLVAR             { BLit($1) }
| VARIABLE ASNTO expr { Asn($1, $3) }
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
