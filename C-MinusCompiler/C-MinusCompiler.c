#include <stdio.h>
#include "ast.h"

extern int yyparse(void);
extern FILE* yyin;
extern int yydebug;
extern Node* astRoot;

int main()
{
	//yydebug = 1;
	yyin = fopen("input.csrc", "rt");
	if (yyin != NULL)
	{
		int result = yyparse();
		switch (result)
		{
		case 0:
			printf("Parse successfull.\n");
			break;

		case 1:
			printf("Invalid input encountered\n");
			break;

		case 2:
			printf("Out of memory\n");
			break;

		default:
			break;
		}
		printAst(astRoot, 0);
		fclose(yyin);
	}
	else
	{
		printf("Fisier inexistent");
	}
}
