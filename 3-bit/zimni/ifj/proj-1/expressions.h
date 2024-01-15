/**
 * @file expressions.h
 * @author Sychra Jakub (xsychr06)
 * @brief Header file for the expression parser
*/

#ifndef __EXPRESSIONS_H__
#define __EXPRESSIONS_H__

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include "scanner.h"


// AST node types
typedef enum {
    PROGRAM,
    VAR_DECLARATION,    //  will both point to decl_var where var|let from this type shall differentiate the structure
    LET_DECLARATION,    //  ***
    FUNC_DECLARATION,
    FUNC_CALL,
    ARGUMENT,
    PARAMETERS,
    EXPRESSION,
    LITERAL, 
    IF,
    WHILE,
    RETURN,
} Type;

// types for Literal values
typedef enum{
    STRING, 
    DOUBLE,
    INT,
    EXPONENTIONAL,
    ID,
    NIL,
} litType;


struct stAST;
typedef struct stAST {
    Type type;
    union{
        struct{
            struct stAST* statements; // statements or vars ordered 
        }program; // toplevel
        struct{
            char* id;
            litType type;
            struct stAST* declaration;
            bool nullable;
        }declaration_var; // var x 
        struct{
            char* id;
            struct stAST* params;
            litType returnType;
            struct stAST* body;
        }declaration_func; // func x (declaration)
        struct{
            char* id;
            struct stAST* args;
            bool forcedUnwrapping;
        }func; // func call
        struct{
            litType type;
            union
            {
                int intValue;
                double doubleValue;
                char* stringValue;
            };
            bool forcedUnwrapping; // optional, only for identifiers created with let that have optional postfix '?'
            
        }literal; // toplevel
        struct{
            token_type_t op; // enum instead of char or string for simplicity
            struct stAST* leftChild;
            struct stAST* rightChild;
        }expression; // Expressions and assignments
        struct{
            struct stAST* condition;
            struct stAST* body;
            struct stAST* astElse; 
        }astIf; // ast prefix because of C keyword
        struct{
            struct stAST* condition;
            struct stAST* body;
        }astWhile; 
        struct{
            struct stAST* expression;
        }astReturn; 
        struct{
            char* name;
            char* id;
            litType type;
            bool nullable;
        }astArgument; 
        struct{
            char* name;
            struct stAST* expr;
        }astParameter;
    }data;
    // points to the next item of the list
    struct stAST* next;
} AST;

// Define a union for data
union Data {
    char id;
    double value;
};


// Define the structure for a node in the expression tree
typedef struct stExpr {
    token_t token;
    bool isE;
    bool forcedUnwrapping;
    struct stExpr* left;
    struct stExpr* right; 
    bool isFunc;
    struct stAST* params;
} *Expr;

// Define a stack structure to hold expressions
typedef struct stStack {
    Expr* data;
    int top;
    int capacity;
} *Stack;
  
// Initialize a stack with a given capacity
Stack createStack(int capacity);
Expr createExpr(token_t token);
void push(Stack stack, Expr expression);
Expr pop(Stack stack);
Expr getTop(Stack stack);
int isEmpty(Stack stack);
void printTree(Expr root, int s);
int getOperation(token_type_t input, token_type_t stack);
token_type_t getFirstTerminal(Stack stack);
void applyRule(Stack stack);
void resolveExpression(Stack stack, Expr expr);


const char *token_type_to_string(token_type_t );
#endif //__EXPRESSIONS_H__