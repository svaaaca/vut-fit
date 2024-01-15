/**
 * @file symtable.c
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation of the symbol table using a height balanced binary search tree (BST).
 * @date 2023-11-20
 */

#include "symtable.h"

void st_init(st_node_t **root) {
	*root = NULL;
}

int st_node_height(st_node_t *node) {
	if(node == NULL) {
		return 0;
	}
	else {
		return node->height;
	}
}

int st_node_balance(st_node_t *node) {
	if(node == NULL) {
		return 0;
	}
	else {
		return st_node_height(node->left) - st_node_height(node->right);
	}
}

void st_insert(st_node_t **root, char *key, st_type_t type, st_scope_t scope, bool defined, bool modifiable, st_datatype_t datatype, int no_params, st_node_t *local_st) {
	if(*root == NULL) {
		*root = (st_node_t *) malloc(sizeof(struct st_node));
		if(root == NULL) {
			exit(INTERNAL_ERROR);
		}
		(*root)->key = key;
		(*root)->type = type;
		(*root)->scope = scope;
		(*root)->defined = defined;
		(*root)->modifiable = modifiable;
		(*root)->datatype = datatype;
		(*root)->no_params = no_params;
		(*root)->local_st = local_st;
		(*root)->left = NULL;
		(*root)->right = NULL;
		(*root)->height = 1;
	}
	else {
		if(strcmp((*root)->key, key) == 0) {
			(*root)->type = type;
			(*root)->scope = scope;
			(*root)->defined = defined;
			(*root)->modifiable = modifiable;
			(*root)->datatype = datatype;
			(*root)->no_params = no_params;
			(*root)->local_st = local_st;
		}
		else if(strcmp((*root)->key, key) > 0) {
			st_insert(&((*root)->left), key, type, scope, defined, modifiable, datatype, no_params, local_st);
		}
		else if(strcmp((*root)->key, key) < 0) {
			st_insert(&((*root)->right), key, type, scope, defined, modifiable, datatype, no_params, local_st);
		}
		(*root)->height = MAX(st_node_height((*root)->left), st_node_height((*root)->right)) + 1;
		int balance = st_node_balance(*root);
		if(balance > 1 && strcmp((*root)->left->key, key) > 0) {
			st_right_rotate(root);
		}
		else if(balance < -1 && strcmp((*root)->right->key, key) < 0) {
			st_left_rotate(root);
		}
		else if(balance > 1 && strcmp((*root)->left->key, key) < 0) {
			st_left_rotate(&((*root)->left));
			st_right_rotate(root);
		}
		else if(balance < -1 && strcmp((*root)->right->key, key) > 0) {
			st_right_rotate(&((*root)->right));
			st_left_rotate(root);
		}
	}
}


bool st_search_function_pararms(st_node_t *root,char *fun_id, int arg_number) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, fun_id) == 0) { 
			if(root->no_params == arg_number) {
				return true;
			}
			else {
				if(root->no_params == -1) {
					return true;
				}
				else{
					return false;
				}
			}
		}
		else if(strcmp(root->key, fun_id) > 0) {
			return st_search_function_pararms(root->left, fun_id, arg_number);
		}
		else if(strcmp(root->key, fun_id) < 0) {
			return st_search_function_pararms(root->right, fun_id, arg_number);
		}
		else {
			return false;
		}
	}
}

bool st_search_id(st_node_t *root, char *key) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			return true;
		}
		else if(strcmp(root->key, key) > 0) {
			return st_search_id(root->left, key);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_search_id(root->right, key);
		}
		else {
			return false;
		}
	}
}

bool st_is_id_mutable(st_node_t *root, char *key) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			return root->modifiable;
		}
		else if(strcmp(root->key, key) > 0) {
			return st_is_id_mutable(root->left, key);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_is_id_mutable(root->right, key);
		}
		else {
			return false;
		}
	}
}

bool st_search_id_defined(st_node_t *root, char *key) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			return root->defined;
		}
		else if(strcmp(root->key, key) > 0) {
			return st_search_id_defined(root->left, key);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_search_id_defined(root->right, key);
		}
		else {
			return false;
		}
	}
}

st_datatype_t st_get_id_type(st_node_t *root, char *key) {
	if(root == NULL) {
		return ST_DATATYPE_UNKNOWN;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			return root->datatype;
		}
		else if(strcmp(root->key, key) > 0) {
			return st_get_id_type(root->left, key);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_get_id_type(root->right, key);
		}
		else {
			return ST_DATATYPE_UNKNOWN;
		}
	}
}

st_scope_t st_get_id_scope(st_node_t *root, char *key){
	if(root == NULL) {
		return ST_SCOPE_UNKNOWN;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			return root->scope;
		}
		else if(strcmp(root->key, key) > 0) {
			return st_get_id_scope(root->left, key);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_get_id_scope(root->right, key);
		}
		else {
			return ST_SCOPE_UNKNOWN;
		}
	}
}

// This function just checks if the ID is in the one of the symtable of DLL list
// It useful, when you want to check expression: var c : Int = a + b
// Where a is in global symtable (global scope) and b is in local symtable (local scope)
bool st_search_id_and_type(st_node_t *root, char *key, st_datatype_t datatype) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			if (root->datatype == datatype) {
				return root->defined;
			}
			else {
				if (datatype == ST_DATATYPE_DOUBLE || datatype == ST_DATATYPE_DOUBLE_NIL) {
                    if (root->datatype == ST_DATATYPE_DOUBLE || root->datatype == ST_DATATYPE_DOUBLE_NIL) {
                        return true;
                    } else {
                        return false;
                    }
                } else if (datatype == ST_DATATYPE_INT_NIL || datatype == ST_DATATYPE_INT) {
                    if (root->datatype == ST_DATATYPE_INT || root->datatype == ST_DATATYPE_INT_NIL) {
                        return true;
                    } else {
                        return false;
                    }
                } else if (datatype == ST_DATATYPE_STRING_NIL || datatype == ST_DATATYPE_STRING) {
                    if (root->datatype == ST_DATATYPE_STRING || root->datatype == ST_DATATYPE_STRING_NIL) {
                        return true;
                    } else {
                        return false;
                    }
                }
                return false;
			}
		}
		else if(strcmp(root->key, key) > 0) {
			return st_search_id_and_type(root->left, key, datatype);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_search_id_and_type(root->right, key, datatype);
		}
		else {
			return false;
		}
	}
}

// This functions is useful for checking, 
// if 2 variables with same name are in same scope is trying to be declared
bool st_search_id_in_same_scope(st_node_t *root, char *key, st_scope_t scope) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, key) == 0) { 
			if(root->scope == scope) {
				return true;
			}
			else {
				return false;
			}
			return true; 
		}
		else if(strcmp(root->key, key) > 0) {
			return st_search_id_in_same_scope(root->left, key, scope);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_search_id_in_same_scope(root->right, key, scope);
		}
		else {
			return false;
		}
	}
}


bool st_search(st_node_t *root, char *key, st_type_t *type, st_scope_t *scope, bool *defined, bool *modifiable, st_datatype_t *datatype, int *no_params, st_node_t **local_st) {
	if(root == NULL) {
		return false;
	}
	else {
		if(strcmp(root->key, key) == 0) {
			// I think I dont need this, I only want to know, if it exists or not
			*type = root->type;
			*scope = root->scope;
			*defined = root->defined;
			*modifiable = root->modifiable;
			*datatype = root->datatype;
			*no_params = root->no_params;
			*local_st = root->local_st;
			return true; 
		}
		else if(strcmp(root->key, key) > 0) {
			return st_search(root->left, key, type, scope, defined, modifiable, datatype, no_params, local_st);
		}
		else if(strcmp(root->key, key) < 0) {
			return st_search(root->right, key, type, scope, defined, modifiable, datatype, no_params, local_st);
		}
		else {
			return false;
		}
	}
}

void st_left_rotate(st_node_t **root) {
	if(*root == NULL) {
		return;
	}
	else {
		st_node_t *temporary = (*root)->right;
		st_node_t *critical = temporary->left;
		temporary->left = *root;
		(*root)->right = critical;
		(*root)->height = MAX(st_node_height((*root)->left), st_node_height((*root)->right)) + 1;
		temporary->height = MAX(st_node_height(temporary->left), st_node_height(temporary->right)) + 1;
		*root = temporary;
	}
}

void st_right_rotate(st_node_t **root) {
	if(*root == NULL) {
		return;
	}
	else {
		st_node_t *temporary = (*root)->left;
		st_node_t *critical = temporary->right;
		temporary->right = *root;
		(*root)->left = critical;
		(*root)->height = MAX(st_node_height((*root)->left), st_node_height((*root)->right)) + 1;
		temporary->height = MAX(st_node_height(temporary->left), st_node_height(temporary->right)) + 1;
		*root = temporary;
	}
}

void st_replace_by_rightmost(st_node_t *target, st_node_t **root) {
	if(*root == NULL) {
		return;
	}
	else {
		if((*root)->right == NULL) {
			target->key = (*root)->key;
			target->type = (*root)->type;
			target->scope = (*root)->scope;
			target->defined = (*root)->defined;
			target->modifiable = (*root)->modifiable;
			target->datatype = (*root)->datatype;
			target->no_params = (*root)->no_params;
			target->local_st = (*root)->local_st;
			if((*root)->left == NULL) {
				free(*root);
				*root = NULL;
			}
			else {
				st_node_t *temporary = *root;
				*root = (*root)->left;
				free(temporary);
				temporary = NULL;
			}
		}
		else {
			st_replace_by_rightmost(target, &((*root)->right));
		}
	}
}

void st_delete(st_node_t **root, char *key) {
	if(*root == NULL) {
		return;
	}
	else {
		if(strcmp((*root)->key, key) > 0) {
			st_delete(&((*root)->left), key);
		}
		else if(strcmp((*root)->key, key) < 0) {
			st_delete(&((*root)->right), key);
		}
		else {
			if(((*root)->left == NULL) && ((*root)->right == NULL)) {
				free(*root);
				*root = NULL;
			}
			else if(((*root)->left != NULL) && ((*root)->right != NULL)) {
				st_replace_by_rightmost(*root, &((*root)->left));
			}
			else {
				st_node_t *temporary = *root;
				if(((*root)->left == NULL) && ((*root)->right != NULL)) {
					*root = (*root)->right;
					free(temporary);
					temporary = NULL;
				}
				else if(((*root)->left != NULL) && ((*root)->right == NULL)) {
					*root = (*root)->left;
					free(temporary);
					temporary = NULL;
				}
			}
		}
	}
	if(*root != NULL) {
		(*root)->height = MAX(st_node_height((*root)->left), st_node_height((*root)->right)) + 1;
		int balance = st_node_balance(*root);
		if(balance > 1 && st_node_balance((*root)->left) >= 0) {
			st_right_rotate(root);
		}
		else if(balance < -1 && st_node_balance((*root)->right) <= 0) {
			st_left_rotate(root);
		}
		else if(balance > 1 && st_node_balance((*root)->left) < 0) {
			st_left_rotate(&((*root)->left));
			st_right_rotate(root);
		}
		else if(balance < -1 && st_node_balance((*root)->right) > 0) {
			st_right_rotate(&((*root)->right));
			st_left_rotate(root);
		}
	}
}

void st_dispose(st_node_t **root) {
	if(*root == NULL) {
		return;
	}
	else {
		st_dispose(&((*root)->left));
		st_dispose(&((*root)->right));
		free(*root);
		*root = NULL;
	}
}

void st_fill_keywords(st_node_t **root) {
	char *keywords[] = {"Double", "else", "func", "if", "Int", "let", "nil", "return", "String", "var", "while"};
	for(int i = 0; i < ST_KEYWORD_COUNT; i++) {
		st_insert(root, keywords[i], ST_TYPE_KEYWORD, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_KW_FUNC, 0, NULL);
	}
}

void st_fill_functions(st_node_t **root) {
	st_insert(root, "readString", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_STRING_NIL, 0, NULL);
	st_insert(root, "readInt", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_INT_NIL, 0, NULL);
	st_insert(root, "readDouble", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_DOUBLE_NIL, 0, NULL);
	st_insert(root, "Int2Double", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_DOUBLE, 1, NULL);
	st_insert(root, "Double2Int", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_INT, 1, NULL);
	st_insert(root, "length", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_INT, 1, NULL);
	st_insert(root, "ord", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_INT, 1, NULL);
	st_insert(root, "chr", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_STRING, 1, NULL);
	st_insert(root, "substring", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_STRING_NIL, 3, NULL);
	st_insert(root, "write", ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, ST_DATATYPE_VOID, -1, NULL);
}

void st_preorder(st_node_t *root) {
	if(root == NULL) {
		return;
	}
	else {
		//st_print_node(root);
		st_preorder(root->left);
		st_preorder(root->right);
	}
}

void st_inorder(st_node_t *root) {
	if(root == NULL) {
		return;
	}
	else {
		st_inorder(root->left);
		st_print_node(root);
		st_inorder(root->right);
	}
}

void st_postorder(st_node_t *root) {
	if(root == NULL) {
		return;
	}
	else {
		st_postorder(root->left);
		st_postorder(root->right);
		//st_print_node(root);
	}
}

void st_print_node(st_node_t *node) {
	if(node != NULL) {
		char *type = NULL;
		char *scope = NULL;
		char *defined = NULL;
		char *modifiable = NULL;
		char *datatype = NULL;
		switch(node->type) {
			case ST_TYPE_VARIABLE:
				type = "variable";
				break;
			case ST_TYPE_FUNCTION:
				type = "function";
				break;
			case ST_TYPE_KEYWORD:
				type = "keyword";
				break;
			default:
				type = "unknown";
				break;
		}
		switch(node->scope) {
			case ST_SCOPE_GLOBAL:
				scope = "global";
				break;
			case ST_SCOPE_LOCAL:
				scope = "local";
				break;
			case ST_SCOPE_TEMPORARY:
				scope = "temporary";
				break;
			default:
				scope = "unknown";
				break;
		}
		if(node->defined == true) {
			defined = "defined";
		}
		else {
			defined = "not defined";
		}
		if(node->modifiable == true) {
			modifiable = "modifiable";
		}
		else {
			modifiable = "not modifiable";
		}
		switch(node->datatype) {
			case ST_DATATYPE_INT:
				datatype = "Int";
				break;
			case ST_DATATYPE_DOUBLE:
				datatype = "Double";
				break;
			case ST_DATATYPE_STRING:
				datatype = "String";
				break;
			case ST_DATATYPE_INT_NIL:
				datatype = "Int?";
				break;
			case ST_DATATYPE_DOUBLE_NIL:
				datatype = "Double?";
				break;
			case ST_DATATYPE_STRING_NIL:
				datatype = "String?";
				break;
			case ST_DATATYPE_KW_FUNC:
				datatype = "keyword/function";
				break;
			default:
				datatype = "unknown";
				break;
		}
		printf("[%s; %s; %s; %s; %s; %s; params: %d]\n", node->key, type, scope, defined, modifiable, datatype, node->no_params);
	}
}

void dll_init(dl_list_t *list) {
	list->first = NULL;
	list->active = NULL;
	list->last = NULL;
}

void dll_insert_first(dl_list_t *list, st_node_t *root) {
	dll_element_t *new_element = (dll_element_t *) malloc(sizeof(struct dll_element));
	if(new_element == NULL) {
		exit(INTERNAL_ERROR);
	}
	new_element->root = root;
	new_element->next = list->first;
	new_element->previous = NULL;
	if(list->first != NULL) {
		list->first->previous = new_element;
	}
	else {
		list->last = new_element;
	}
	list->first = new_element;
}

void dll_insert_last(dl_list_t *list, st_node_t *root) {
	dll_element_t *new_element = (dll_element_t *) malloc(sizeof(struct dll_element));
	if(new_element == NULL) {
		exit(INTERNAL_ERROR);
	}
	new_element->root = root;
	new_element->next = NULL;
	new_element->previous = list->last;
	if(list->last != NULL) {
		list->last->next = new_element;
	}
	else {
		list->first = new_element;
	}
	list->last = new_element;
}

void dll_insert_after(dl_list_t *list, st_node_t *root) {
	if(list->active != NULL) {
		dll_element_t *new_element = (dll_element_t *) malloc(sizeof(struct dll_element));
		if(new_element == NULL) {
			exit(INTERNAL_ERROR);
		}
		new_element->root = root;
		new_element->next = list->active->next;
		new_element->previous = list->active;
		list->active->next = new_element;
		if(list->active == list->last) {
			list->last = new_element;
		}
		else {
			new_element->next->previous = new_element;
		}
	}
}

void dll_insert_before(dl_list_t *list, st_node_t *root) {
	if(list->active != NULL) {
		dll_element_t *new_element = (dll_element_t *) malloc(sizeof(struct dll_element));
		if(new_element == NULL) {
			exit(INTERNAL_ERROR);
		}
		new_element->root = root;
		new_element->next = list->active;
		new_element->previous = list->active->previous;
		list->active->previous = new_element;
		if(list->active == list->first) {
			list->first = new_element;
		}
		else {
			new_element->previous->next = new_element;
		}
	}
}

void dll_first(dl_list_t *list) {
	list->active = list->first;
}

void dll_last(dl_list_t *list) {
	list->active = list->last;
}

void dll_next(dl_list_t *list) {
	if(list->active != NULL) {
		list->active = list->active->next;
	}
}

void dll_previous(dl_list_t *list) {
	if(list->active != NULL) {
		list->active = list->active->previous;
	}
}

void dll_get_first(dl_list_t *list, st_node_t **root) {
	if(list->first != NULL) {
		*root = list->first->root;
	}
}

void dll_get_active(dl_list_t *list, st_node_t **root) {
	if(list->active != NULL) {
		*root = list->active->root;
	}
}

void dll_get_last(dl_list_t *list, st_node_t **root) {
	if(list->last != NULL) {
		*root = list->last->root;
	}
}

void dll_set(dl_list_t *list, st_node_t *root) {
	if(list->active != NULL) {
		list->active->root = root;
	}
}

bool dll_is_active(dl_list_t *list) {
	return (list->active != NULL);
}

void dll_delete_first(dl_list_t *list) {
	if(list->first != NULL) {
		if(list->first == list->active) {
			list->active = NULL;
		}
		dll_element_t *temporary;
		temporary = list->first;
		if(list->first == list->last) {
			list->first = NULL;
			list->last = NULL;
		}
		else {
			list->first = list->first->next;
			list->first->previous = NULL;
		}
		free(temporary);
		temporary = NULL;
	}
}

void dll_delete_last(dl_list_t *list) {
	if(list->last != NULL) {
		if(list->last == list->active) {
			list->active = NULL;
		}
		dll_element_t *temporary;
		temporary = list->last;
		if(list->first == list->last) {
			list->first = NULL;
			list->last = NULL;
		}
		else {
			list->last = list->last->previous;
			list->last->next = NULL;
		}
		free(temporary);
		temporary = NULL;
	}
}

void dll_delete_after(dl_list_t *list) {
	if(list->active != NULL) {
		if(list->active->next != NULL) {
			dll_element_t *temporary;
			temporary = list->active->next;
			list->active->next = temporary->next;
			if(temporary == list->last) {
				list->last = list->active;
			}
			else {
				temporary->next->previous = list->active;
			}
			free(temporary);
			temporary = NULL;
		}
	}
}

void dll_delete_before(dl_list_t *list) {
	if(list->active != NULL) {
		if(list->active->previous != NULL) {
			dll_element_t *temporary;
			temporary = list->active->previous;
			list->active->previous = temporary->previous;
			if(temporary == list->first) {
				list->first = list->active;
			}
			else {
				temporary->previous->next = list->active;
			}
			free(temporary);
			temporary = NULL;
		}
	}
}

void dll_dispose(dl_list_t *list) {
	list->active = NULL;
	list->last = NULL;
	while(list->first != NULL) {
		dll_element_t *temporary;
		temporary = list->first->next;
		free(list->first);
		list->first = temporary;
	}
}
