#ifndef __SYMBOLSTABLE_H
#define __SYMBOLSTABLE_H

#include "ast.h"
#define MAX_SYMBOL_NAME 255
#define MAX_DATATYPE_NAME 255
#define SIZE 211

typedef enum IdentifierScope { Local = 0, Global } IdentifierScope;
typedef enum SymbolType { Function = 0, Variable = 1, Parameter = 2 } SymbolType;

typedef struct symTableEntry {
	char symbolName[MAX_SYMBOL_NAME]; 
	char dataType[MAX_DATATYPE_NAME];
	SymbolType symbolType;
	IdentifierScope symbolScope;
	char contextName[MAX_SYMBOL_NAME];
	struct symTableEntry* next;
}SymTableEntry;

static SymTableEntry** hashTable;

void initHashTable();
void insert(char* name, char* type, SymbolType symbolType, IdentifierScope scope, char* context);
void printSymbolsTable();
void generateSymbolsTable(Node* astRoot, int level, Node* parent);
#endif // !__SYMBOLSTABLE_H
