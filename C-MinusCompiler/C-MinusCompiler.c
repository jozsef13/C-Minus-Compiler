#include <stdio.h>
#include "symbols.h"
#include <errno.h>

extern FILE* yyin;
//extern int yylex(void);
extern int yyparse(void);
extern int yydebug;
//const char* lexUnits[] = {
//	"END",
//	"ELSE",
//	"IF",
//	"INT",
//	"LONG",
//	"DOUBLE",
//	"FLOAT",
//	"SHORT",
//	"UNSIGNED",
//	"VOLATILE",
//	"RETURN",
//	"VOID",
//	"WHILE",
//	"ADD",
//	"SUBSTRACT",
//	"MULTIPLY",
//	"DIVIDE",
//	"SMALLER",
//	"SMALLER_OR_EQUAL",
//	"GREATER",
//	"GREATER_OR_EQUAL",
//	"EQUAL",
//	"NOT_EQUAL",
//	"ASSIGN",
//	"END_OF_INSTRUCTION",
//	"COMMA",
//	"LEFT_PARANTHESIS",
//	"RIGHT_PARANTHESIS",
//	"LEFT_BRACKET",
//	"RIGHT_BRACKET",
//	"LEFT_BRACE",
//	"RIGHT_BRACE",
//	"ID",
//	"NUM"
//};

int main()
{
	//yydebug = 1;
	yyin = fopen("input.csrc", "rt");
	if (yyin != NULL) {
		int result = yyparse();
		switch (result)
		{
		case 0:
			printf("\nParse Successfull\n");
			break;
		case 1:
			printf("\nInvalid input encountered!\n");
			break;
		case 2:
			printf("Out of memory!");
			break;
		default:
			break;
		}
		fclose(yyin);
	}
	else {
		printf("Fisier inexistent");
	}
}
