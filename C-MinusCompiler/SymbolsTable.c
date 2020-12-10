#include "SymbolsTable.h"
#include <malloc.h>
#include <string.h>
#include <stdio.h>

int indexValue = 0;

void initHashTable()
{
	int i;
	hashTable = malloc(SIZE * sizeof(SymTableEntry*));
	for (i = 0; i < SIZE; i++)
		hashTable[i] = NULL;
}

void insert(char* name, char* type, SymbolType symbolType, IdentifierScope scope, char* context)
{
	unsigned int hashValue = indexValue;
	SymTableEntry* list = hashTable[hashValue];

	list = (SymTableEntry*)malloc(sizeof(SymTableEntry));
	sprintf(list->symbolName, "%s", name);
	list->symbolType = symbolType;
	list->symbolScope = scope;
	sprintf(list->dataType, "%s", type);
	sprintf(list->contextName, "%s", context);
	list->next = hashTable[hashValue];
	hashTable[hashValue] = list;
	indexValue++;
}

void printSymbolsTable()
{
	int i;
	printf("\n----------------------- The Symbols Table -----------------\n");
	for (i = 0; i < indexValue; i++)
	{
		if (hashTable[i] != NULL)
		{
			SymTableEntry* list = hashTable[i];
			while (list != NULL)
			{
				printf("Symbol name: %s; Data type: %s; ", list->symbolName, list->dataType);
				if (list->symbolType == Function)
				{
					printf("Symbol type: Function; ");
				}
				else if (list->symbolType == Variable)
				{
					printf("Symbol type: Variable; ");
				}
				else if (list->symbolType == Parameter)
				{
					printf("Symbol type: Parameter; ");
				}

				if (list->symbolScope == Global)
				{
					printf("Symbol scope: Global; ");
				}
				else if (list->symbolScope == Local)
				{
					printf("Symbol scope: Local; ");
				}
				printf("Context: %s\n", list->contextName);
				list = list->next;
			}
		}
	}
}

void generateSymbolsTable(Node* astRoot, int level, Node* parent)
{
	int idx = 0;
	char* type = " ";
	enum IdentifierScope scope = Local;
	enum SymbolType symType = Variable;
	Node* localParent = parent;
	if (astRoot)
	{
		if (strcmp(astRoot->type, "FunctionDeclaration") == 0)
		{
			for (idx = 0; idx < astRoot->numLinks; idx++)
			{
				if (strcmp(astRoot->links[idx]->type, "TypeSpecifier") == 0)
				{
					type = astRoot->links[idx]->extraData;
					break;
				}
			}
			insert(astRoot->extraData, type, Function, Global, localParent->type);
		}

		if (strcmp(astRoot->type, "VariableDeclaration") == 0)
		{
			symType = Variable;
			scope = Local;
			for (idx = 0; idx < astRoot->numLinks; idx++)
			{
				if (strcmp(astRoot->links[idx]->type, "TypeSpecifier") == 0)
				{
					type = astRoot->links[idx]->extraData;
					break;
				}
			}

			if (strcmp(parent->type, "Declaration") && level <= 4)
			{
				scope = Global;
			}

			if (strcmp(parent->type, "ParametersList") == 0)
			{
				symType = Parameter;
			}
			insert(astRoot->extraData, type, symType, scope, localParent->type);
		}
		for (idx = 0; idx < astRoot->numLinks; idx++)
		{
			localParent = astRoot;
			generateSymbolsTable(astRoot->links[idx], level + 1, localParent);
		}
	}
}