%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE EQUAL SEMI EOF
%token NEWLINE LPAREN RPAREN COMMA PRINT EXCHANGE WITH
%token LBRACE RBRACE
%token <int> LITERAL
%token <string> VARIABLE

%left SEMI
%left NEWLINE
%right EQUAL

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
| expr NEWLINE { Expr $1 }
;

expr:
| expr PLUS   expr    { Binop($1, Add, $3) }
| expr MINUS  expr    { Binop($1, Sub, $3) }
| expr TIMES  expr    { Binop($1, Mul, $3) }
| expr DIVIDE expr    { Binop($1, Div, $3) }
| VARIABLE            { Var($1) }
| LITERAL             { Lit($1) }
| VARIABLE EQUAL expr { Asn($1, $3) }
| EXCHANGE VARIABLE WITH VARIABLE {Swap($2, $4)}
;

