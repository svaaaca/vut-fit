/**
 * @file parser.h
 * @author Sychra Jakub (xsychr06)
 * @brief Header file for the syntactic analysis
*/

#ifndef __PARSER_H__
#define __PARSER_H__

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "scanner.h"
#include "error.h"
#include "expressions.h"
#include "symtable.h"

st_node_t* getGlobalSymtable();

AST* createProgram();
AST* createVar(Type astType, char* id, litType type, AST* decl, bool nullable);
AST* createFuncDec();
AST* createFunc(char* id, AST* args, bool unwrapping);
AST* createExpression(int a, Expr expression);
AST* createIf(AST* condition, AST* body, AST* astElse); 
AST* createWhile(AST* condition, AST* body);
AST* createReturn(AST* expression);

AST* ExprToAST(Expr expression);
AST* parameters(token_t* token);

bool checkTokenType(token_t* token, token_type_t requiredType);
bool isExprValid(token_t* token);
bool isIDVal(token_t* token);
bool checkType(token_t* token);
bool checkTokenAssignment(token_t* token);

void addToEndOfList(AST** list, AST* node);
void nextToken(token_t* token);
void astPrint(AST* root);
void checkIdentifier(token_t* token);
void checkReturnType(token_t* token);
void checkReturn(token_t* token);

void program(token_t* token);
AST* arguments(token_t* token);
void body(token_t* token, bool expectBrace, bool inFunc);
AST* parameters(token_t* token);


Expr expression(token_t* token, token_t* overrideToken, bool override);


const char* typeToString(Type type);

#endif //__PARSER_H__