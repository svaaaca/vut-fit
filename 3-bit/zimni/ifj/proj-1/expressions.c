/**
 * @file expressions.c
 * @author Sychra Jakub (xsychr06)
 * @brief Implementation of expression parser
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include "expressions.h"

// Initialize a stack with a given capacity
Stack createStack(int capacity) {
    Stack stack = malloc(sizeof(struct stStack));
    stack->data = malloc(sizeof(Expr) * capacity);
    stack->capacity = capacity;
    stack->top = -1;
    return stack;
}

// Creates the Expression structure
// Contains important information of partly or fully resolved expression
Expr createExpr(token_t token){
    Expr newNode = malloc(sizeof(struct stExpr));
    newNode->token = token;
    newNode->isE = false;
    newNode->isFunc = false;
    newNode->forcedUnwrapping = false;
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;
}

// Push an expression onto the stack
void push(Stack stack, Expr expression) {
    if (stack->top == stack->capacity - 1) {
        exit(99);
    }
    stack->data[++stack->top] = expression;
}

// Pop an expression from the stack
Expr pop(Stack stack) {
    if (stack->top < 0) {
        return NULL;
    }
    return stack->data[stack->top--];
}

// Function to get the top item from the stack without removing it
Expr getTop(Stack stack) {
    if (stack->top < 0) {
        return NULL;
    }

    return stack->data[stack->top];
}

// Check if the stack is empty
int isEmpty(Stack stack) {
    return (stack->top < 0);
}

// 1 == > (applyRule)
// 2 == < (insert)
int getOperation(token_type_t input, token_type_t stack){
    if(stack == -1){
        return 2;
    }
    switch(input){
        case token_plus:
        case token_minus:
            if( stack == token_plus || stack == token_minus || 
                stack == token_mul || stack == token_div ||
                stack == token_identifier || stack == token_string || 
                stack == token_int || stack == token_double ||
                stack == token_exclamation_mark || stack == token_nil){
                return 1;
            }
            return 2;
        case token_mul:
        case token_div:
            if(stack == token_mul || stack == token_div || stack == token_exclamation_mark){
                return 1;
            }
            return 2;
        case token_identifier:
        case token_int:
        case token_nil:
        case token_double:
        case token_string:
            if (stack == token_identifier || 
                stack == token_int || 
                stack == token_nil ||
                stack == token_double || 
                stack == token_string ||
                stack == token_right_parenthesis){
                    return 3;
                }else if(stack == token_exclamation_mark){
                    exit(2);
                }
            return 2;
        case token_equal:
        case token_greater:
        case token_greater_equal:
        case token_less:
        case token_less_equal:
        case token_not_equal:
            if( stack == token_equal ||
                stack == token_greater ||
                stack == token_greater_equal ||
                stack == token_less ||
                stack == token_less_equal ||
                stack == token_not_equal){
                    exit(2);
                }
            return 1;
        case token_exclamation_mark:
            if (stack == token_int || 
                stack == token_double || 
                stack == token_string ||
                stack == token_right_parenthesis ||
                stack == token_nil ||
                stack == token_exclamation_mark)
            {
                exit(7);
            }
            if(stack == token_identifier){
                return 1;
            }
            return 2;
        case token_nil_unar_operator:
            if (stack == token_greater ||
                stack == token_greater_equal ||
                stack == token_less ||
                stack == token_less_equal ||
                stack == token_equal ||
                stack == token_not_equal ||
                stack == token_nil_unar_operator){
                return 2;
            }
            return 1;
        default:
            // unimplemented or faulty cases
            exit(2);
    }
}

// get first terminal in stack (non-E)
token_type_t getFirstTerminal(Stack stack){
    for(int i = stack->top; i >= 0; i--){
        if(!stack->data[i]->isE){
             //printf("ttx\n");
            return stack->data[i]->token.type;
        }
    }
    return -1;
}

// applies expression rules
void applyRule(Stack stack){
    Expr top = getTop(stack);
    // 1
    if(!top->isE){
        if(top->token.type == token_exclamation_mark){
            pop(stack); // get rid of !
            getTop(stack)->forcedUnwrapping = true;
            return;
        }
        if(top->token.type != token_identifier 
        && top->token.type != token_double 
        && top->token.type != token_int 
        && top->token.type != token_nil
        && top->token.type != token_exp_number
        && top->token.type != token_string) {
            exit(2);
        }
        top->isE = true;
        return;
    }
    top = pop(stack);
    Expr op = pop(stack);
    Expr bottom = pop(stack);

    if(top == NULL || op == NULL || bottom == NULL){
        exit(2);
    }
    
    op->right = top;
    op->left = bottom;
    op->isE = true;
    push(stack, op);
}

// Input function from parser, apllies rules one by one
void resolveExpression(Stack stack, Expr expr){
    
    if (expr == NULL){
        exit(2);
    }

    while(1){
        //  check if terminal or nonterminal and get operation  Input -> Stack
        int op = getOperation(expr->token.type, getFirstTerminal(stack));

        if(op == 1){ // resolve
            applyRule(stack);
        }else if(op == 2){ // push
            push(stack, expr);
            return;
        }else if(op == 3){ // special cases -> leave expression and solve in parser 
            return; 
        }
    }
}