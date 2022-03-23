%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE EQUAL SEMI EOF
%token NEWLINE
%token <int> LITERAL
%token <string> VARIABLE

%left SEMI
%right EQUAL

%left PLUS MINUS
%left TIMES DIVIDE

%start program
%type <Ast.program> program

%%

program: expr_list EOF { $1 }

expr_list: 
/* nothing */ { [] }
| expr NEWLINE  expr_list { $1 :: $3 }

expr:
| expr PLUS   expr    { Binop($1, Add, $3) }
| expr MINUS  expr    { Binop($1, Sub, $3) }
| expr TIMES  expr    { Binop($1, Mul, $3) }
| expr DIVIDE expr    { Binop($1, Div, $3) }
| expr SEMI   expr    { Seq($1, $3) }
| VARIABLE            { Var($1) }
| LITERAL             { Lit($1) }
| VARIABLE EQUAL expr { Asn($1, $3) }

