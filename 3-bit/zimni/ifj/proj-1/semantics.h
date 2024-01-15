/**
 * @file semantics.h
 * @brief Header file for the semantic analysis 
 * @brief using a Double Linked List (DLL) for the symbol table and Abstract Syntax Tree (AST)
 * @author Dias Assatulla
*/

#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "symtable.h"
#include "expressions.h"
#include "scanner.h"
#include "parser.h"
#include "error.h"


/**
 * @brief function to check if the type is nil
 * @param st_datatype_t type
 * @return bool

*/
bool is_datatype_nil(st_datatype_t type);
/**
 * @brief function for handling expression semantics
 * @param AST* program
 * @return void
*/
void semantic_expression(AST *expression, st_datatype_t varType, dll_element_t *symtable_element);

/**
 * @brief function to search the ID in the DLL list
 * @param AST* program
 * @return int
*/
int search_dll_list_symbol(dll_element_t *symtable_element, char* id, st_datatype_t datatype);

/**
 * @brief function for getting the type of the element from symbol ID
 * @param dll_element_t *symtable_element
 * @param char *id
 * @return st_datatype_t
*/
st_datatype_t dll_get_id_type(dll_element_t *symtable_element, char *id);

/**
 * @brief function for getting the type of the element from expression
 * @param AST *expression
 * @param dll_element_t *symtable_element
 * @return st_datatype_t
*/
st_datatype_t expression_get_type(AST *expression, dll_element_t *symtable_element);

/**
 * @brief function for checking if the ID is exist
 * @param dll_element_t *symtable_element
 * @param char *id
 * @return bool
*/
bool dll_is_id_exist(dll_element_t *symtable_element, char *id);

/**
 * @brief function for checking if the ID is mutable
 * @param dll_element_t *symtable_element
 * @param char *id
 * @return bool
*/
bool dll_is_id_mutable(dll_element_t *symtable_element, char *id);

/**
 * @brief function for checking if the ID is defined
 * @param dll_element_t *symtable_element
 * @param char *id
 * @return bool
*/
bool dll_is_id_defined(dll_element_t *symtable_element, char *id);

/**
 * @brief function for getting the type from the litType
 * @param litType type
 * @return int
*/
int get_type_from_litType(litType type);

/**
 * @brief function for handling semantics return
 * @param st_datatype_t varType 
 * @param AST* definitionVar 
 * @param dll_element_t *symtable_element
 * @return void
*/
void semantic_return(st_datatype_t varType, AST* definitionVar, dll_element_t *symtable_element);

/**
 * @brief function for handling semantics
 * @param AST* program
 * @return int
*/
void semantic_handler(st_datatype_t varType, AST* definitionVar, dll_element_t *symtable_element);

/**
* @brief function for adding symbol to the table
* @param st_node_t* symtable
* @param bool nullable. To check if it is String or String?
* @param int keyword_mutable. To check if it is var or let definition
* @param int keyword_type. To check if it is Int, Double or String
* @param char* id. The identifier of the variable
*/
void add_symbol_to_table(dl_list_t *symtable_list, st_datatype_t datatype, bool defined, int keyword_mutable, char* id, int scope_handler, int number_params );

/**
 * @brief function for checking the data type
 * @param int keyword_type. To check if it is Int, Double or String
 * @param bool nullable. To check if it is String or String?
*/
st_datatype_t get_datatype(int keyword_type, bool nullable);


/**
 * @brief function for checking the scope
 * @param int scope_handler. To check if it is global or local
*/
st_scope_t get_scope(int scope_handler);


#endif // SEMANTICS_H