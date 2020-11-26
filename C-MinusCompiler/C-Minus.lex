D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
#include "ast.h"
#include "C-Minus.tab.h"

void count();
void error();
%}

%%
"/*"        { comment(); } 
"else"      { count(); return(ELSE); }
"if"        { count(); return(IF); }
"int"       { count(); return(INT); }
"return"    { count(); return(RETURN); }
"void"      { count(); return(VOID); }
"while"     { count(); return(WHILE); }

{L}({L}|{D})*		{ count(); yylval.strings = strdup(yytext);  return(ID); }
{D}+                { count(); yylval.intVal = atoi(yytext); return(NUM); }

"+"			{ count(); return(ADD); }
"-"			{ count(); return(SUBSTRACT); }
"*"         { count(); return(MULTIPLY); }
"/"         { count(); return(DIVIDE); }
"<"         { count(); return(SMALLER); }
"<="        { count(); return(SMALLER_OR_EQUAL); }
">"         { count(); return(GREATER); }
">="        { count(); return(GREATER_OR_EQUAL); }
"=="        { count(); return(EQUAL); }
"!="        { count(); return(NOT_EQUAL); }
"="			{ count(); return(ASSIGN); }
";"			{ count(); return(END_OF_INSTRUCTION); }
","         { count(); return(COMMA); }
"("         { count(); return(LEFT_PARANTHESIS); }
")"         { count(); return(RIGHT_PARANTHESIS); }
"["         { count(); return(LEFT_BRACKET); }
"]"         { count(); return(RIGHT_BRACKET); }
"{"         { count(); return(LEFT_BRACE); }
"}"         { count(); return(RIGHT_BRACE); }

[ \t\v\n\f]		{ count(); }
.			{ error(); }

%%

yywrap()
{
	return(1);
}


comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}

int column = 0;

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}

void error()
{
	printf("Error! The string %s is not recognized!", yytext);
}