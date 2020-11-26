#ifndef __AST_H
#define __AST_H

#define MAX_NODE_TYPE 1000
#define MAX_EXTRA_DATA 1000

typedef struct node {
	char type[MAX_NODE_TYPE];
	int numLinks;
	char extraData[MAX_EXTRA_DATA];
	struct node** links;
} Node;

Node* createProgramNode(Node* declarationList);
Node* createListNode(const char* listName, Node* firstLink);
Node* createDeclarationNode(Node* varFunDeclaration);
Node* createVarDeclaration(Node* typeSpecifier, const char* varName, int value);
Node* createTypeSpecifier(const char* typeName);
Node* createFunctionDeclarationNode(Node* typeSpecifier, const char* functionName, Node* paramsList, Node* compoundStatement);
Node* createParametersNode(Node* paramsList);
Node* createCompoundStatement(Node* localDeclList, Node* instructionsList);
Node* createStatementNode(Node* statementType);
Node* createExpressionStatementNode(Node* expression);
Node* createSelectionStatementNode(Node* expression, Node* thenStatement, Node* elseStatement);
Node* createIterationStatementNode(Node* expression, Node* statement);
Node* createReturnStatementNode(Node* expression);
Node* createExpressionNode(Node* expression);
Node* createVariableNode(const char* identifierName, Node* expression);
Node* createSimpleExpressionNode(Node* firstAdditiveExpression, Node* relop, Node* secondAdditiveExpression);
Node* createRelationalOperatorNode(const char* operatorType);
Node* createAdditiveExpressionNode(Node* expression, Node* addop, Node* term);
Node* createAddSubOperatorNode(const char* opratorType);
Node* createTermNode(Node* term, Node* mulop, Node* factor);
Node* createMulDivOperatorNode(const char* operatorType);
Node* createFactorNode(Node* expression, int value);
Node* createCallNode(const char* identifier, Node* args);
Node* createArgsNode(Node* argsList);

Node* createDefaultNode(const char* nodeName, unsigned int linksCount);
Node* resizeNodeLinks(Node* nodeToResize, unsigned int newSize);
void addLinkToList(Node* listNode, Node* linkToAdd);
void printAst(Node* ast, int level);
#endif