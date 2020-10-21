#include <stdio.h>
#include "symbols.h"
#include <errno.h>

extern FILE* yyin;
extern int yylex(void);

const char* lexUnits[] = {
	"END",
	"ELSE",
	"IF",
	"INT",
	"LONG",
	"DOUBLE",
	"FLOAT",
	"SHORT",
	"UNSIGNED",
	"VOLATILE",
	"RETURN",
	"VOID",
	"WHILE",
	"ADD",
	"SUBSTRACT",
	"MULTIPLY",
	"DIVIDE",
	"SMALLER",
	"SMALLER_OR_EQUAL",
	"GREATER",
	"GREATER_OR_EQUAL",
	"EQUAL",
	"NOT_EQUAL",
	"ASSIGN",
	"END_OF_INSTRUCTION",
	"COMMA",
	"LEFT_PARANTHESIS",
	"RIGHT_PARANTHESIS",
	"LEFT_BRACKET",
	"RIGHT_BRACKET",
	"LEFT_BRACE",
	"RIGHT_BRACE",
	"ID",
	"NUM"
};

int main()
{
	int tokenValue = 0;
	yyin = fopen("input.csrc", "rt");
	
	if (yyin != NULL) {
		while ((tokenValue = yylex()) != END) {
			printf(" -> TOKEN ID: %d; TOKEN VALUE: %s \n", tokenValue, lexUnits[tokenValue]);
		}
	}
	else {
		printf("Fisierul de intrare nu poate fi deschis. Erorare: %d", errno);
	}
}
