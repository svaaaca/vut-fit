/*** 
 * @file generator.h
 * @brief Header file for generator.c
 * @author Tomas Sedo
*/

#ifndef __GENERATOR_H__
#define __GENERATOR_H__

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include "parser.h"
#include "expressions.h"
#include "scanner.h"
#include "symtable.h"

/**
 * @brief Function for cleaning the frames.
 */
void cleanFrames();

/**
 * @brief Function for generating expressions.
 * 
 * @param root pointer to the root statement.
 */
void evaluate(AST* root);

/**
 * @brief Function for initilazing generator.
 * 
 * @param root pointer to the root statement.
 */
void initGenerator(AST* root);

/**
 * @brief Helper function for getting current scope of the identifier.
 * 
 * @param key pointer to ID.
 * 
 * @return scope in printing format(GF, LF, TF).
 */
const char* getScope(char *key);

/**
 * @brief Helper function for getting type of the identifier.
 * 
 * @param key pointer to ID.
 * 
 * @return scope in printing format(int, string, double).
 */
const char* getType(char * key);

/**
 * @brief Helper function for correcting the string in case of special chars(escape sequences etc.).
 * 
 * @param string pointer to string.
 * 
 * @return corrected string where special chars are replaced by \xyz where xyz is ascii number.
 */
char* correctString(char* string);

/**
 * @brief Function for generating arithmetic (ADD, SUB, MUL).
 * 
 * @param operation what operation is this for.
 * 
 * @param leftChild left child of the expression.
 * 
 * @param rightChild right child of the expression.
 * 
 * @param var_name name of the variable where the result will be stored.
 */
void generateArithmetic(const char *operation, AST* leftChild, AST* rightChild, char *var_name);

/**
 * @brief Function for generating division (DIV, IDIV).
 * 
 * @param leftChild left child of the expression.
 * 
 * @param rightChild right child of the expression.
 * 
 * @param var_name name of the variable where the result will be stored.
 */
void generateDivision(AST* leftChild, AST* rightChild, char* var_name);

/**
 * @brief Function for generating logic (<, >, ==).
 * 
 * @param operation what operation is this for.
 * 
 * @param leftChild left child of the expression.
 * 
 * @param rightChild right child of the expression.
 * 
 * @param var_name name of the variable where the result will be stored.
 */

void generateLogic(const char* operation, AST* leftChild, AST* rightChild, char* var_name);

/**
 * @brief Prints the header.
 */
void generator_init();

/**
 * @brief Generates code for each statement(Line of code).
 * 
 * @param root Pointer to the root statement.
 */
void generateCode(AST* root);

/**
 * @brief Prints the header and prepares all the statements.
 * 
 * @param program Pointer to the program.
 */
void generateProgram(AST* program);

/**
 * @brief Generates variable declaration(var and let).
 * 
 * @param declaration_var Pointer to the declared variable.
 */
void generateDeclarationVar(AST* declaration_var);

/**
 * @brief Generates function declaration.
 * 
 * @param declaration_func Pointer to the declared function.
 */
void generateDeclarationFunc(AST* declaration_func);

/**
 * @brief Generates function calling.
 * 
 * @param func_call Pointer to the called function.
 */
void generateFuncCall(AST* func_call);

/**
 * @brief Generates function calling for built in String functions.
 * 
 * @param func_call Pointer to the called function.
 * 
 * @param var_name name of the variable where the result will be stored.
 */
void generateFuncCallString(AST* func_call, char* var_name);

/**
 * @brief Generates function calling for built in Conversion functions.
 * 
 * @param func_call Pointer to the called function.
 * 
 * @param var_name name of the variable where the result will be stored.
 */
void generateFuncCallConversion(AST* func_call, char* var_name);

/**
 * @brief Generates function calling for built in Read functions.
 * 
 * @param func_call Pointer to the called function.
 * 
 * @param var_name name of the variable where the result will be stored.
 */
void generateFuncCallRead(AST* func_call, char* var_name);

/**
 * @brief Generates function parametres.
 * 
 * @param func_param Pointer to the function parameter.
 */
void generateParams(AST* func_param);

/**
 * @brief Generates function calling arguments.
 * 
 * @param func_args Pointer to the function calling argument.
 */
void generateArgs(AST* func_args);

/**
 * @brief Generates function return.
 * 
 * @param func_return Pointer to the function return.
 */
void generateReturn(AST* func_return);

/**
 * @brief Reverses arguments when calling functions so they are assigned to the right parameter.
 * 
 * @param args Pointer to the arg.
 */
void generateReverseArgs(AST* args);

/**
 * @brief Generates literal.
 * 
 * @param literal Pointer to the literal.
 */
void generateLiteral(AST* literal);

/**
 * @brief Generates expression.
 * 
 * @param expression Pointer to the expression.
 * @param var_name Pointer to the variable name.
 */
void generateExpression(AST* expression, char* var_name);

/**
 * @brief Generates while.
 * 
 * @param root Pointer to the while.
 */
void generateWhile(AST* root);

/**
 * @brief Generates if.
 * 
 * @param root Pointer to the if.
 */
void generateIf(AST* root);

/**
 * @brief Generates Assignment.
 * 
 * @param root Pointer to the assignment (=).
 */
void generateAssignment(AST* root);

/**
 * @brief Add symbol to the table.
 * 
 * @param symtable_list Pointer to the symtable list.
 * 
 * @param datatype Data type of the symbol.
 * 
 * @param defined Bool value fo setting if the symbol is defined.
 * 
 * @param keyword_mutable Value which indicates if symbol can be modified.
 * 
 * @param id Name of the symbol.
 * 
 * @param scope_handler Number of the scope.
 * 
 * @param number_params Number of the parameters.
 */
void add_symbol_to_table(dl_list_t *symtable_list, st_datatype_t datatype, bool defined, int keyword_mutable, char* id, int scope_handler, int number_params );


#endif // __GENERATOR_H__
