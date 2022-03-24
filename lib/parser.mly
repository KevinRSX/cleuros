%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE EQUAL EOF
%token NEWLINE LPAREN RPAREN COMMA PRINT EXCHANGE WITH
%token LBRACE RBRACE IF ELSE LESS WHILE GREATER
%token RETURN
%token <int> LITERAL
%token <string> VARIABLE
%token <string> FUNCTION

%left NEWLINE
%right EQUAL

%left LESS GREATER
%left PLUS MINUS
%left TIMES DIVIDE

%start program
%type <Ast.program> program

%%

program: stmt_list EOF { $1 }

stmt_list:
/* nothing */ { [] }
| stmt stmt_list { $1::$2 }
;

stmt:
| expr NEWLINE { Expr($1) }
| LBRACE NEWLINE stmt_list RBRACE NEWLINE { Block($3) }
| IF expr NEWLINE stmt ELSE stmt { If($2, $4, $6)}
| WHILE expr NEWLINE stmt { While($2, $4)}
| RETURN expr NEWLINE { Return($2)}
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

args: 
 expr { [$1] }
| expr COMMA args { $1::$3 }