%{ 
  #include <stdio.h>
  int yyerror(char * s);
  extern int yylex(void);
%}

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
%token ID
%token NUM

%start program
%%

program 
    : declaration_list
    ;

declaration_list 
    : declaration_list declaration 
    | declaration
    ;

declaration
    : var_declaration
    | fun_declaration
    ;

var_declaration
    : type_specifier ID END_OF_INSTRUCTION
    | type_specifier ID LEFT_BRACKET NUM RIGHT_BRACKET END_OF_INSTRUCTION END_OF_INSTRUCTION
    ;

type_specifier
    : INT
    | VOID
    ;

fun_declaration
    : type_specifier ID LEFT_PARANTHESIS params RIGHT_PARANTHESIS compound_stmt
    ;

params
    : param_list
    | VOID
    ;

param_list
    : param_list COMMA param
    | param
    ;

param
    : type_specifier ID
    | type_specifier ID LEFT_BRACKET RIGHT_BRACKET
    ;

compound_stmt 
    : LEFT_BRACE local_declarations statement_list RIGHT_BRACE
    ;

local_declarations
    : local_declarations var_declaration
    | /* empty */
    ;

statement_list
    : statement_list statement
    | /* empty */
    ;

statement 
    : expression_stmt
    | compound_stmt
    | selection_stmt
    | iteration_stmt
    | return_stmt
    ;

expression_stmt
    : expression END_OF_INSTRUCTION
    | END_OF_INSTRUCTION
    ;

selection_stmt
    : IF LEFT_PARANTHESIS expression RIGHT_PARANTHESIS statement
    | IF LEFT_PARANTHESIS expression RIGHT_PARANTHESIS statement ELSE statement
    ;

iteration_stmt
    : WHILE LEFT_PARANTHESIS expression RIGHT_PARANTHESIS statement
    ;

return_stmt
    : RETURN END_OF_INSTRUCTION
    | RETURN expression END_OF_INSTRUCTION
    ;

expression
    : var ASSIGN expression 
    | simple_expression
    ;

var
    : ID
    | ID LEFT_BRACKET expression RIGHT_BRACKET
    ;

simple_expression
    : additive_expression relop additive_expression
    | additive_expression
    ;

relop
    : SMALLER_OR_EQUAL
    | SMALLER
    | GREATER
    | GREATER_OR_EQUAL
    | EQUAL
    | NOT_EQUAL
    ;

additive_expression
    : additive_expression addop term
    | term
    ;

addop
    : ADD
    | SUBSTRACT
    ;

term
    : term mulop factor
    | factor
    ;

mulop
    : MULTIPLY
    | DIVIDE
    ;

factor
    : LEFT_PARANTHESIS expression RIGHT_PARANTHESIS 
    | var
    | call
    | NUM
    ;

call
    : ID LEFT_PARANTHESIS args RIGHT_PARANTHESIS
    ;

args
    : arg_list
    | /* empty */
    ;

arg_list
    : arg_list COMMA expression
    | expression
    ;

%%

int yyerror(char * s) 
/* yacc error handler */
{    
	printf ( "%s\n", s); 
	return 0;
}  