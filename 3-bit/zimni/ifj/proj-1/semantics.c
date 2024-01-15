/**
 * @file semantics.c
 * @author Dias Assatulla
 * @brief Implementation of semantic analysis functions
*/

#include "semantics.h"
#include "symtable.h"

bool is_unar_nil_operator = false;

int get_type_from_litType(litType type) {
    switch (type)
    {
    case STRING:
        return token_string;
        break;
    case DOUBLE:
        return token_double;
        break;
    case INT:
        return token_int;
        break;
    case EXPONENTIONAL:
        return token_double;
        break;
    case ID:
        return token_identifier;
        break;
    case NIL:
        return token_nil;
        break;
    default:
        return 0;
        break;
    }
}

st_datatype_t get_datatype(int keyword_type, bool nullable) {
    if (keyword_type == keyword_Double) {
        return nullable ? ST_DATATYPE_DOUBLE_NIL : ST_DATATYPE_DOUBLE;
    } else if (keyword_type == keyword_String) {
        return nullable ? ST_DATATYPE_STRING_NIL : ST_DATATYPE_STRING;
    } else if (keyword_type == keyword_Int) {
        return nullable ? ST_DATATYPE_INT_NIL : ST_DATATYPE_INT;
    } else {
        switch (keyword_type)
        {
        case token_string:
            return ST_DATATYPE_STRING;
            break;
        case token_int:
            return ST_DATATYPE_INT;
            break;
        case token_double:
            return ST_DATATYPE_DOUBLE;
            break;
        case token_nil:
            return ST_DATATYPE_VOID; // means no return type
            break;
        default:
            exit(SEMANTIC_ERROR_MATH_TYPE);
            break;
        }
    }
}

st_scope_t get_scope(int scope_handler) {
    if (scope_handler == 0) {
        return ST_SCOPE_GLOBAL;
    }
    else {
        return ST_SCOPE_LOCAL;
    }
}


st_datatype_t dll_get_id_type(dll_element_t *symtable_element, char *id) {
	if(st_search_id(symtable_element->root, id)) { 
		return st_get_id_type(symtable_element->root, id);
	}
	
	if(symtable_element->previous == NULL) {
		exit(SEMANTIC_ERROR_UNDEFINED_VARIABLE);
	}
    else {
        return dll_get_id_type(symtable_element->previous, id);
    }
	
}

bool dll_is_id_mutable(dll_element_t *symtable_element, char *id) {
    if(st_search_id(symtable_element->root, id)) { 
        return st_is_id_mutable(symtable_element->root, id);
    }
    
    if(symtable_element->previous == NULL) {
        exit(SEMANTIC_ERROR_UNDEFINED_VARIABLE);
    }
    else {
        return dll_is_id_mutable(symtable_element->previous, id);
    }
    
}

bool dll_is_id_exist(dll_element_t *symtable_element, char *id) {
    if(st_search_id(symtable_element->root, id)) { 
        return true;
    }
    
    if(symtable_element->previous == NULL) {
        return false;
    }
    else {
        return dll_is_id_exist(symtable_element->previous, id);
    }
    
}

bool dll_is_id_defined(dll_element_t *symtable_element, char *id) {
    if(st_search_id_defined(symtable_element->root, id)) {
        return true;
    }
    
    if(symtable_element->previous == NULL) {
        return false;
    }
    else {
        return dll_is_id_defined(symtable_element->previous, id);
    }
    
}

bool is_datatype_nil(st_datatype_t datatype) {
    if (datatype == ST_DATATYPE_DOUBLE_NIL || datatype == ST_DATATYPE_INT_NIL || datatype == ST_DATATYPE_STRING_NIL) {
        return true;
    }
    else {
        return false;
    }
}

int search_dll_list_symbol(dll_element_t *symtable_element, char* id, st_datatype_t datatype) {
    
    if(st_search_id_defined(symtable_element->root, id)) {
        if (st_search_id_and_type(symtable_element->root, id, datatype)) {
            return 0; // All good
        }
        else {
            return 7; // Bad type
        }
    }

    if (symtable_element->previous == NULL) {
        return 5; // Undefined variable
    }
    else 
        return search_dll_list_symbol(symtable_element->previous, id, datatype);
    
}

st_datatype_t expression_get_type(AST *expression, dll_element_t *symtable_element) {
    if(expression->type == LITERAL) {
        switch (expression->data.literal.type)
        {
        case STRING:
            return ST_DATATYPE_STRING;
            break;
        case DOUBLE:
            return ST_DATATYPE_DOUBLE;
            break;
        case INT:
            return ST_DATATYPE_INT;
            break;
        case ID:
            return dll_get_id_type(symtable_element, expression->data.literal.stringValue);
            break;
        default:
            break;
        }
    }
    else if (expression->type == FUNC_CALL) {
        return dll_get_id_type(symtable_element, expression->data.declaration_func.id);
    }
    else {
        if (expression->data.expression.leftChild != NULL) {
            return expression_get_type(expression->data.expression.leftChild, symtable_element);
        }
        if (expression->data.expression.rightChild != NULL) {
            return expression_get_type(expression->data.expression.rightChild, symtable_element);
        }

    }
    return ST_DATATYPE_UNKNOWN;
}

void semantic_expression(AST *expression, st_datatype_t varType, dll_element_t *symtable_element) {
    int result;
    st_datatype_t checkForcedUnwrap;
    if(expression->type == LITERAL) {
        switch (expression->data.literal.type)
        {
        case STRING:
            if (varType != ST_DATATYPE_STRING && varType != ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        case DOUBLE:
            if (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        case INT:
            if (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        case ID:     
            result = search_dll_list_symbol(symtable_element, expression->data.literal.stringValue, varType);
            if(result != 0) {
                exit(result);
            }

            checkForcedUnwrap = st_get_id_type(symtable_element->root, expression->data.literal.stringValue);

            if(is_datatype_nil(checkForcedUnwrap)) {
                if(!is_datatype_nil(varType)) { // if varType is not nil
                    if(!expression->data.literal.forcedUnwrapping) {
                        if(is_unar_nil_operator) {
                            is_unar_nil_operator = false;
                        }  
                        else {
                            exit(SEMANTIC_ERROR_MATH_TYPE);
                        }
                    }
                }
            }
            break;
        default:
            break;
        }
    }
    else if (expression->type == FUNC_CALL) {
        result = search_dll_list_symbol(symtable_element, expression->data.declaration_func.id, varType);
        if(result != 0) {
            exit(result);
        }
    }
    else {
        if(expression->type == EXPRESSION) {
            if((expression->data.expression.op == token_minus || expression->data.expression.op == token_mul || 
            expression->data.expression.op == token_div) && 
            (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL)) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            if(expression->data.expression.op == token_nil_unar_operator){ 
                is_unar_nil_operator = true;
            }
        }
        if (expression->data.expression.leftChild != NULL) {
            semantic_expression(expression->data.expression.leftChild, varType, symtable_element);
        }
        if (expression->data.expression.rightChild != NULL) {
            semantic_expression(expression->data.expression.rightChild, varType, symtable_element);
        }
    }
}


void semantic_handler(st_datatype_t varType, AST* definitionVar, dll_element_t *symtable_element) {
    int result;
    st_datatype_t checkForcedUnwrap;
    switch (definitionVar->data.literal.type) {
        case STRING:
            if (varType != ST_DATATYPE_STRING && varType != ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        case DOUBLE:
            if (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL ||
                varType == ST_DATATYPE_INT || varType == ST_DATATYPE_INT_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        case INT:
            if (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        case EXPONENTIONAL:
            break;
        case ID:
            result = search_dll_list_symbol(symtable_element, definitionVar->data.literal.stringValue, varType);
            if(result != 0) {
                exit(result);
            }
            checkForcedUnwrap = st_get_id_type(symtable_element->root, definitionVar->data.literal.stringValue);
            if(is_datatype_nil(checkForcedUnwrap)) {
                if(!is_datatype_nil(varType)) { // if varType is not nil
                    if(!definitionVar->data.literal.forcedUnwrapping) {
                        exit(SEMANTIC_ERROR_MATH_TYPE);
                    }
                }
            }
            break;
        case NIL:
            if (varType != ST_DATATYPE_DOUBLE_NIL && varType != ST_DATATYPE_INT_NIL && varType != ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_MATH_TYPE);
            }
            break;
        default:
            break;
    }
}

void semantic_return(st_datatype_t varType, AST* definitionVar, dll_element_t *symtable_element) {
    if (varType == ST_DATATYPE_VOID) {
        exit(SEMANTIC_ERROR_RETURN_FUNCTION);
    }
    int result;

    if(definitionVar->type == LITERAL) {
        switch (definitionVar->data.literal.type) {
        case STRING:
            if (varType != ST_DATATYPE_STRING && varType != ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_BAD_TYPE_OPERANDS);
            }
            
            break;
        case DOUBLE:
            if (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL ||
                varType == ST_DATATYPE_INT || varType == ST_DATATYPE_INT_NIL) {
                exit(SEMANTIC_ERROR_BAD_TYPE_OPERANDS);
            }
            break;
        case INT:
            if (varType == ST_DATATYPE_STRING || varType == ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_BAD_TYPE_OPERANDS);
            }
            break;
        case EXPONENTIONAL:
            break;
        case ID:
            result = search_dll_list_symbol(symtable_element, definitionVar->data.literal.stringValue, varType);
            if(result != 0) {
                if(result == 5) {
                    exit(SEMANTIC_ERROR_UNDEFINED_VARIABLE);
                }
                else {
                    exit(SEMANTIC_ERROR_BAD_TYPE_OPERANDS);
                }
            }
            break;
        case NIL:
            if (varType != ST_DATATYPE_DOUBLE_NIL && varType != ST_DATATYPE_INT_NIL && varType != ST_DATATYPE_STRING_NIL) {
                exit(SEMANTIC_ERROR_BAD_TYPE_OPERANDS);
            }
            break;
        default:
            break;
        }
    }
    else if (definitionVar->type == FUNC_CALL) {
        result = search_dll_list_symbol(symtable_element, definitionVar->data.declaration_func.id, varType);
        if(result != 0) {
            exit(result);
        }
    }
    else {
        if (definitionVar->data.expression.leftChild != NULL) {
            semantic_expression(definitionVar->data.expression.leftChild, varType, symtable_element);
        }
        if (definitionVar->data.expression.rightChild != NULL) {
            semantic_expression(definitionVar->data.expression.rightChild, varType, symtable_element);
        }
    }
    
}


void add_symbol_to_table(dl_list_t *symtable_list, st_datatype_t datatype, bool defined, int keyword_mutable, char* id, int scope_handler, int number_params ) {
    bool is_mutable = false;
    st_scope_t scope = get_scope(scope_handler);
    st_type_t type;
    switch (keyword_mutable) {
        case keyword_var:
            type = ST_TYPE_VARIABLE;
            is_mutable = true;
            break;
        case keyword_let:
            type = ST_TYPE_VARIABLE;
            is_mutable = false;
            break;
        case keyword_func:
            type = ST_TYPE_FUNCTION;
            is_mutable = false;
            break;
        default:
            exit(SYNTAX_ERROR);
    }
    if (datatype == ST_DATATYPE_DOUBLE_NIL || datatype == ST_DATATYPE_INT_NIL || datatype == ST_DATATYPE_STRING_NIL) {
        defined = true;
    }

    if (st_search_id_in_same_scope(symtable_list->active->root, id, scope)) {
        exit(SEMANTIC_ERROR_UNDEFINED_FUNCTION); // Redeclaration of variable or function
    }
    else {
        st_insert(&symtable_list->active->root, id, type, scope, defined, is_mutable, datatype, number_params, NULL);
    }    
}
