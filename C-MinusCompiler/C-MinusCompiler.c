#include <stdio.h>
#include "ast.h"
#include "SymbolsTable.h"

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
		printf("\n---------------------- The syntax tree ------------------");
		printAst(astRoot, 0);
		initHashTable();
		generateSymbolsTable(astRoot, 0, astRoot);
		printSymbolsTable();
		fclose(yyin);
	}
	else
	{
		printf("Fisier inexistent");
	}
}
