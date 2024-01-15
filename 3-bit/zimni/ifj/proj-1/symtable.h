/**
 * @file symtable.h
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Header file for the symbol table using a height balanced binary search tree (BST).
 * @date 2023-11-20
 */

#ifndef __SYMTABLE_H__
#define __SYMTABLE_H__

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "error.h"

#define ST_KEYWORD_COUNT 11                 // Number of keywords in the symbol table.
#define MAX(a, b) ((a) > (b) ? (a) : (b))   // Maximum of two values.

/**
 * @brief Symbol table type enumeration.
 * 
 */
typedef enum st_type {
    ST_TYPE_VARIABLE,   // Variable.
    ST_TYPE_KEYWORD,    // Keyword.
    ST_TYPE_FUNCTION    // Function.
} st_type_t;

/**
 * @brief Symbol table scope enumeration.
 * 
 */
typedef enum st_scope {
    ST_SCOPE_GLOBAL,    // Global scope.
    ST_SCOPE_LOCAL,     // Local scope.
    ST_SCOPE_TEMPORARY,  // Temporary scope.
    ST_SCOPE_UNKNOWN
} st_scope_t;

/**
 * @brief Symbol table datatype enumeration.
 * 
 */
typedef enum st_datatype {
    ST_DATATYPE_INT,        // Integer.
    ST_DATATYPE_DOUBLE,     // Double.
    ST_DATATYPE_STRING,     // String.
    ST_DATATYPE_INT_NIL,    // Integer with a nil value.
    ST_DATATYPE_DOUBLE_NIL, // Double with a nil value.
    ST_DATATYPE_STRING_NIL, // String with a nil value.
    ST_DATATYPE_VOID,       // Void for functions
    ST_DATATYPE_UNKNOWN,    // Uknown datatype.
    ST_DATATYPE_KW_FUNC     // Keyword and function.
} st_datatype_t;

/**
 * @brief Symbol table node structure.
 * 
 */
typedef struct st_node {
    char *key;                  // Key (name).
    st_type_t type;             // Type (variable, keyword, function).
    st_scope_t scope;           // Scope (global, local, temporary).
    bool defined;               // Defined flag.
    bool modifiable;            // Modifiable flag (true for 'var', false otherwise).
    st_datatype_t datatype;     // Datatype (int, double, string, int with a nil value, double with a nil value, string with a nil value, keyword and function).
    int no_params;              // Number of function parameters (0 for variables and keywords).
    struct st_node *local_st;   // Pointer to the local symbol table (NULL for variables and keywords).
    struct st_node *left;       // Pointer to the left child.
    struct st_node *right;      // Pointer to the right child.
    int height;                 // Height.
} st_node_t;

/**
 * @brief Double linked list element structure.
 * 
 */
typedef struct dll_element {
    struct st_node *root;           // Pointer to the root.
    struct dll_element *next;       // Pointer to the next.
    struct dll_element *previous;   // Pointer to the previous.
} dll_element_t;

/**
 * @brief Double linked list structure.
 * 
 */
typedef struct dl_list {
    struct dll_element *first;  // Pointer to the first.
    struct dll_element *active; // Pointer to the active.
    struct dll_element *last;   // Pointer to the last.
} dl_list_t;


st_datatype_t st_get_id_type(st_node_t *root, char *key);
st_scope_t st_get_id_scope(st_node_t *root, char *key);

bool st_search_function_pararms(st_node_t *root,char *fun_id, int arg_number);

bool st_search_id(st_node_t *root, char *key);
bool st_is_id_mutable(st_node_t *root, char *key);
bool st_search_id_defined(st_node_t *root, char *key);

/**
 * @brief Search ID in the symbol table and its type.
*/
bool st_search_id_and_type(st_node_t *root, char *key, st_datatype_t datatype);

/**
 * @brief Search ID in the symbol table and its scope.
*/
bool st_search_id_in_same_scope(st_node_t *root, char *key, st_scope_t scope);
/**
 * @brief Initialization of the symbol table.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_init(st_node_t **root);

/**
 * @brief Get the height of a symbol table node.
 * 
 * @param node Pointer to the symbol table node.
 * 
 * @return Height of the symbol table node.
 */
int st_node_height(st_node_t *node);

/**
 * @brief Get the balance of a symbol table node.
 * 
 * @param node Pointer to the symbol table node.
 * 
 * @return Balance of the symbol table node.
 */
int st_node_balance(st_node_t *node);

/**
 * @brief Insert a new node into the symbol table.
 * 
 * @param root Pointer to the symbol table root node.
 * @param key Symbol table node key.
 * @param type Symbol table node type.
 * @param scope Symbol table node scope.
 * @param defined Symbol table node defined flag.
 * @param modifiable Symbol table node modifiable flag.
 * @param datatype Symbol table node datatype.
 * @param no_params Symbol table node number of function parameters.
 * @param local_st Symbol table node pointer to the local symbol table.
 */
void st_insert(st_node_t **root, char *key, st_type_t type, st_scope_t scope, bool defined, bool modifiable, st_datatype_t datatype, int no_params, st_node_t *local_st);

/**
 * @brief Search for a node in the symbol table.
 * 
 * @param root Pointer to the symbol table root node.
 * @param key Symbol table node key.
 * @param type Pointer to the symbol table node type.
 * @param scope Pointer to the symbol table node scope.
 * @param defined Pointer to the symbol table node defined flag.
 * @param modifiable Pointer to the symbol table node modifiable flag.
 * @param datatype Pointer to the symbol table node datatype.
 * @param no_params Pointer to the symbol table node number of function parameters.
 * @param local_st Pointer to the symbol table node pointer to the local symbol table.
 * 
 * @return True if the node was found, false otherwise.
 */
bool st_search(st_node_t *root, char *key, st_type_t *type, st_scope_t *scope, bool *defined, bool *modifiable, st_datatype_t *datatype, int *no_params, st_node_t **local_st);

/**
 * @brief Rotate a symbol table node to the left.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_left_rotate(st_node_t **root);

/**
 * @brief Rotate a symbol table node to the right.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_right_rotate(st_node_t **root);

/**
 * @brief Replace a node in the symbol table with its rightmost child.
 * 
 * @param target Pointer to the symbol table node to be replaced.
 * @param root Pointer to the symbol table root node.
 */
void st_replace_by_rightmost(st_node_t *target, st_node_t **root);

/**
 * @brief Delete a node from the symbol table.
 * 
 * @param root Pointer to the symbol table root node.
 * @param key Symbol table node key to be deleted.
 */
void st_delete(st_node_t **root, char *key);

/**
 * @brief Dispose of the symbol table.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_dispose(st_node_t **root);

/**
 * @brief Fill the symbol table with keywords.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_fill_keywords(st_node_t **root);

/**
 * @brief Fill the symbol table with functions.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_fill_functions(st_node_t **root);

/**
 * @brief Print the symbol table in preorder.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_preorder(st_node_t *root);

/**
 * @brief Print the symbol table in inorder.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_inorder(st_node_t *root);

/**
 * @brief Print the symbol table in postorder.
 * 
 * @param root Pointer to the symbol table root node.
 */
void st_postorder(st_node_t *root);

/**
 * @brief Print a symbol table node.
 * 
 * @param node Pointer to the symbol table node.
 */
void st_print_node(st_node_t *node);

/**
 * @brief Initialization of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_init(dl_list_t *list);

/**
 * @brief Insert a new element into the double linked list as the first element.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_insert_first(dl_list_t *list, st_node_t *root);

/**
 * @brief Insert a new element into the double linked list as the last element.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_insert_last(dl_list_t *list, st_node_t *root);

/**
 * @brief Insert a new element after the active element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_insert_after(dl_list_t *list, st_node_t *root);

/**
 * @brief Insert a new element before the active element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_insert_before(dl_list_t *list, st_node_t *root);

/**
 * @brief Set the active element of the double linked list to the first element.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_first(dl_list_t *list);

/**
 * @brief Set the active element of the double linked list to the last element.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_last(dl_list_t *list);

/**
 * @brief Set the active element of the double linked list to the next element.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_next(dl_list_t *list);

/**
 * @brief Set the active element of the double linked list to the previous element.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_previous(dl_list_t *list);

/**
 * @brief Get the value of the first element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_get_first(dl_list_t *list, st_node_t **root);

/**
 * @brief Get the value of the active element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_get_active(dl_list_t *list, st_node_t **root);

/**
 * @brief Get the value of the last element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_get_last(dl_list_t *list, st_node_t **root);

/**
 * @brief Set the value of the active element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 * @param root Pointer to the symbol table root node.
 */
void dll_set(dl_list_t *list, st_node_t *root);

/**
 * @brief Check if the double linked list is active.
 * 
 * @param list Pointer to the double linked list.
 * 
 * @return True if the double linked list is active, false otherwise.
 */
bool dll_is_active(dl_list_t *list);

/**
 * @brief Delete the first element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_delete_first(dl_list_t *list);

/**
 * @brief Delete the last element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_delete_last(dl_list_t *list);

/**
 * @brief Delete the element after the active element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_delete_after(dl_list_t *list);

/**
 * @brief Delete the element before the active element of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_delete_before(dl_list_t *list);

/**
 * @brief Dispose of the double linked list.
 * 
 * @param list Pointer to the double linked list.
 */
void dll_dispose(dl_list_t *list);

#endif // __SYMTABLE_H__
