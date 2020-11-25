%{ 
  #include <stdio.h>
  #include "ast.h"

  Node* astRoot = NULL;
  int yyerror(char * s);
  extern int yylex(void);
%}
%union{
    Node *node;
    char* strings;
    int intVal;
}

%token END
%token ELSE
%token IF
%token INT
%token LONG
%token DOUBLE
%token FLOAT
%token SHORT
%token UNSIGNED
%token VOLATILE
%token RETURN
%token VOID
%token WHILE
%token ADD
%token SUBSTRACT
%token MULTIPLY
%token DIVIDE
%token SMALLER
%token SMALLER_OR_EQUAL
%token GREATER
%token GREATER_OR_EQUAL
%token EQUAL
%token NOT_EQUAL
%token ASSIGN
%token END_OF_INSTRUCTION
%token COMMA
%token LEFT_PARANTHESIS
%token RIGHT_PARANTHESIS
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_BRACE
%token RIGHT_BRACE
%token <strings> ID
%token <intVal> NUM

%type <node> program
%type <node> declaration_list
%type <node> declaration
%type <node> var_declaration
%type <node> type_specifier
%type <node> fun_declaration
%type <node> params
%type <node> param_list
%type <node> param
%type <node> compound_stmt
%type <node> local_declarations
%type <node> statement_list
%type <node> statement
%type <node> expression_stmt
%type <node> selection_stmt
%type <node> iteration_stmt
%type <node> return_stmt
%type <node> expression
%type <node> var
%type <node> simple_expression
%type <node> relop
%type <node> additive_expression
%type <node> addop
%type <node> term
%type <node> mulop
%type <node> factor
%type <node> call
%type <node> args
%type <node> arg_list

%start program
%%
program 
    : declaration_list { $$ = createProgramNode($1); astRoot = $$; }
    ;

declaration_list 
    : declaration_list declaration { $$ = $1; addLinkToList($$, $2); }
    | declaration { $$ = createListNode("DeclarationsList", $1); }
    ;

declaration
    : var_declaration { $$ = createDeclarationNode($1); }
    | fun_declaration { $$ = createDeclarationNode($1); }
    ;

var_declaration
    : type_specifier ID END_OF_INSTRUCTION { $$ = createVarDeclaration($1, $2, 0); }
    | type_specifier ID LEFT_BRACKET NUM RIGHT_BRACKET END_OF_INSTRUCTION { $$ = createVarDeclaration($1, $2, $4); }
    ;

type_specifier
    : INT { $$ = createTypeSpecifier("INT"); }
    | VOID { $$ = createTypeSpecifier("VOID"); }
    ;

fun_declaration
    : type_specifier ID LEFT_PARANTHESIS params RIGHT_PARANTHESIS compound_stmt { $$ = createFunctionDeclarationNode($1, $2, $4, $6); }
    ;

params
    : param_list { $$ = createParametersNode($1); }
    | VOID { $$ = createParametersNode(NULL); }
    ;

param_list
    : param_list COMMA param { $$ = $1; addLinkToList($$, $3); }
    | param { $$ = createListNode("ParametersList", $1); }
    ;

param
    : type_specifier ID { $$ = createVarDeclaration($1, $2, 0); }
    | type_specifier ID LEFT_BRACKET RIGHT_BRACKET { $$ = createVarDeclaration($1, $2, 0); }
    ;

compound_stmt 
    : LEFT_BRACE local_declarations statement_list RIGHT_BRACE { $$ = createCompoundStatement($2, $3); }
    ;

local_declarations
    : local_declarations var_declaration { $$ = $1; addLinkToList($$, $2); }
    | /* empty */
    ;

statement_list
    : statement_list statement { $$ = $1; addLinkToList($$, $2); }
    | /* empty */
    ;

statement 
    : expression_stmt { $$ = createStatementNode($1); }
    | compound_stmt { $$ = createStatementNode($1); }
    | selection_stmt { $$ = createStatementNode($1); }
    | iteration_stmt { $$ = createStatementNode($1); }
    | return_stmt { $$ = createStatementNode($1); }
    ;

expression_stmt
    : expression END_OF_INSTRUCTION { $$ = createExpressionStatementNode($1); }
    | END_OF_INSTRUCTION { $$ = createExpressionStatementNode(NULL); }
    ;

selection_stmt
    : IF LEFT_PARANTHESIS expression RIGHT_PARANTHESIS statement { $$ = createSelectionStatementNode($3, $5, NULL); }
    | IF LEFT_PARANTHESIS expression RIGHT_PARANTHESIS statement ELSE statement { $$ = createSelectionStatementNode($3, $5, $7); }
    ;

iteration_stmt
    : WHILE LEFT_PARANTHESIS expression RIGHT_PARANTHESIS statement { $$ = createIterationStatementNode($3, $5); }
    ;

return_stmt
    : RETURN END_OF_INSTRUCTION { $$ = createReturnStatementNode(NULL); }
    | RETURN expression END_OF_INSTRUCTION { $$ = createReturnStatementNode($2); }
    ;

expression
    : var ASSIGN expression {  addLinkToList($$, $1); $$ = $3;} 
    | simple_expression { $$ = createExpressionNode($1); }
    ;

var
    : ID { $$ = createVariableNode($1, NULL); }
    | ID LEFT_BRACKET expression RIGHT_BRACKET { $$ = createVariableNode($1, $3); }
    ;

simple_expression
    : additive_expression relop additive_expression { $$ = createSimpleExpressionNode($1, $2, $3); }
    | additive_expression  { $$ = createSimpleExpressionNode($1, NULL, NULL); }
    ;

relop
    : SMALLER_OR_EQUAL { $$ = createRelationalOperatorNode("<="); }
    | SMALLER { $$ = createRelationalOperatorNode("<"); }
    | GREATER { $$ = createRelationalOperatorNode(">"); }
    | GREATER_OR_EQUAL { $$ = createRelationalOperatorNode(">="); }
    | EQUAL { $$ = createRelationalOperatorNode("=="); }
    | NOT_EQUAL { $$ = createRelationalOperatorNode("!="); }
    ;

additive_expression
    : additive_expression addop term { $$ = createAdditiveExpressionNode($1, $2, $3); }
    | term { $$ = $1; }
    ;

addop
    : ADD { $$ = createAddSubOperatorNode("+"); }
    | SUBSTRACT { $$ = createAddSubOperatorNode("-"); }
    ;

term
    : term mulop factor { $$ = createTermNode($1, $2, $3); }
    | factor { $$ = $1; }
    ;

mulop
    : MULTIPLY { $$ = createMulDivOperatorNode("*"); }
    | DIVIDE { $$ = createMulDivOperatorNode("'\'"); }
    ;

factor
    : LEFT_PARANTHESIS expression RIGHT_PARANTHESIS { $$ = createFactorNode($2, 0); }
    | var { $$ = createFactorNode($1, 0); }
    | call { $$ = createFactorNode($1, 0); }
    | NUM  { $$ = createFactorNode(NULL, $1); }
    ;

call
    : ID LEFT_PARANTHESIS args RIGHT_PARANTHESIS { $$ = createCallNode($1, $3); }
    ;

args
    : arg_list { $$ = createArgsNode($1); }
    | /* empty */
    ;

arg_list
    : arg_list COMMA expression { $$ = $1; addLinkToList($$, $3); }
    | expression { $$ = createListNode("ArgumentsList", $1); }
    ;

%%

int yyerror(char * s) 
/* yacc error handler */
{    
	printf ( "%s\n", s); 
	return 0;
}  