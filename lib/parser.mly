%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE EQUAL EOF
%token SEMI LPAREN RPAREN COMMA PRINT EXCHANGE WITH
%token LBRACE RBRACE IF ELSE LESS WHILE GREATER
%token RETURN
%token INT BOOL
%token <int> LITERAL
%token <string> VARIABLE
%token <string> FUNCTION

%left SEMI
%right EQUAL

%left LESS GREATER
%left PLUS MINUS
%left TIMES DIVIDE

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
        body = $6;
    }
}
| typ FUNCTION LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
{
    {
        rtyp = $1;
        fname = $2;
        args = $4;
        body = $7;
    }
}
;

/* formals_opt */
formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }
;

formals_list:
  VARIABLE { [$1] }
  | VARIABLE COMMA formals_list { $1::$3 }
;

stmt_list:
/* nothing */ { [] }
| stmt stmt_list { $1::$2 }
;


/* if-else only supports one statement at this moment and is bounded to else
   if-else and while also must be wrapped with braces */
stmt:
| expr SEMI { Expr($1) }
| LBRACE stmt_list RBRACE { Block($2) }
| IF expr LBRACE stmt RBRACE ELSE LBRACE stmt RBRACE { If($2, $4, $8)}
| WHILE expr LBRACE stmt RBRACE { While($2, $4)}
| RETURN expr SEMI { Return($2)}
;

expr:
| expr PLUS   expr    { Binop($1, Add, $3) }
| expr MINUS  expr    { Binop($1, Sub, $3) }
| expr TIMES  expr    { Binop($1, Mul, $3) }
| expr DIVIDE expr    { Binop($1, Div, $3) }
| expr LESS expr      { Binop($1, Less, $3)}
| expr GREATER expr   { Binop($1, Greater, $3) }
| VARIABLE            { Var($1) }
| LITERAL             { Lit($1) }
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
