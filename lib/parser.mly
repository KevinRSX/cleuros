%token <int> Ast.INT
%token <string> Ast.VAR


%start expr
%type <Ast.expr> expr
%%

expr:
| VARIABLE            { Ast.Var($1) }
| LITERAL             { Ast.Lit($1) }