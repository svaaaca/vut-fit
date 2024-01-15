/**
 * @file parser.c
 * @author Sychra Jakub (xsychr06)
 * @brief Implementation of syntax analysis
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include "parser.h"
#include "semantics.h"
#include "symtable.h"
#include "generator.h"
// GLOBALS ---
// main AST node
AST* prog;
// current AST context, used for correct statement assignment
AST* currentContext = NULL;
// used for error handling in special cases of two differing expressions on one line
bool eolCheck = false;
// handles consecutive statements
bool consCheck = false;
// Global symtable for variables
st_node_t *global_symtable = NULL;
dl_list_t *symtable_list;
st_node_t *local_symtable = NULL; // If we see {, we initialize local symtable and if we see }, we dispose it
bool returnCheck = false; 
int scope_counter = 0;
int number_params = 0; // Counts and adds to symtable number of parameters in function
int arg_counter = 0; // Need to check if number of arguments and parameters are the same when calling function

// ----    ---

st_node_t* getGlobalSymtable() {
    return global_symtable;
}

// creates toplevel AST structure
AST* createProgram(){
    AST* program = malloc(sizeof(AST));
    program->type = PROGRAM;
    program->data.program.statements = NULL;
    program->next = NULL;
    return program;
}

// creates toplevel AST structure
AST* createFuncDec(){
    AST* program = malloc(sizeof(AST));
    program->type = FUNC_DECLARATION;
    program->data.declaration_func.id = NULL;
    program->data.declaration_func.params = NULL;
    program->data.declaration_func.returnType = NIL; // base is nil
    program->data.declaration_func.body = NULL;
    program->next = NULL;
    return program;
}

// create func call AST
AST* createFunc(char* id, AST* params, bool unwrapping){
    AST* program = malloc(sizeof(AST));
    program->type = FUNC_CALL;
    program->data.func.id = id;
    program->data.func.args = params;
    program->data.func.forcedUnwrapping = unwrapping;
    return program;
}

// create if AST
AST* createIf(AST* condition, AST* body, AST* astElse){
    AST* program = malloc(sizeof(AST));
    program->type = IF;
    program->data.astIf.condition = condition;
    program->data.astIf.body = body;
    program->data.astIf.astElse = astElse;
    return program;
}

// create while AST
AST* createWhile(AST* condition, AST* body){
    AST* program = malloc(sizeof(AST));
    program->type = WHILE;
    program->data.astWhile.condition = condition;
    program->data.astWhile.body = body;
    return program;
}

// create return AST
AST* createReturn(AST* expr){
    AST* program = malloc(sizeof(AST));
    program->type = RETURN;
    program->data.astReturn.expression = expr;
    return program;
}

// create var/let declaration AST
AST* createVar(Type astType, char* id, litType type, AST* decl, bool nullable){
    AST* program = malloc(sizeof(AST));
    program->type = astType;
    program->data.declaration_var.id = id;
    program->data.declaration_var.type = type;
    program->data.declaration_var.declaration = decl;
    program->data.declaration_var.nullable = nullable;
    return program;
}

// create parameters for function call
AST* createParameters(AST* expr){
    AST* program = malloc(sizeof(AST));
    program->type = PARAMETERS;
    program->data.astParameter.expr = expr;
    return program;
}

AST* createArguments(){
    AST* program = malloc(sizeof(AST));
    program->type = ARGUMENT;
    return program;
}


// == createLiteral && == createBinary(expr) && == create fcCall(_)
AST* ExprToAST(Expr expression){
    
    // is literal?
    if(expression->isFunc){
        // if params are not empty, cycle through and make a linked list of AST params
        AST* paramAST = expression->params;

        // param NULL if empty and AST list if not
        return createFunc(expression->token.value.string_value, paramAST, expression->forcedUnwrapping);
            // if params empty -> id else fccall
    }else if(expression->left == NULL && expression->right == NULL){
        AST* lit = malloc(sizeof(AST));
        lit->type = LITERAL;

        if(expression->token.type == token_int){
            lit->data.literal.type = INT;
            lit->data.literal.intValue = expression->token.value.int_value;
        }else if(expression->token.type == token_string){
            lit->data.literal.type = STRING;
            lit->data.literal.stringValue = expression->token.value.string_value;
        }else if(expression->token.type == token_double){
            lit->data.literal.type = DOUBLE;
            lit->data.literal.doubleValue = expression->token.value.double_value;
        }else if(expression->token.type == token_identifier){
            lit->data.literal.type = ID;
            lit->data.literal.stringValue = expression->token.value.string_value;
            lit->data.literal.forcedUnwrapping = expression->forcedUnwrapping;
        }else if(expression->token.type == token_nil){
            lit->data.literal.type = NIL;
        }else{
            exit(2);
        }
        
        return lit;
    }else{
        AST* bin = malloc(sizeof(AST));
        bin->type = EXPRESSION;
        bin->data.expression.op = expression->token.type;
        bin->data.expression.leftChild = ExprToAST(expression->left);
        bin->data.expression.rightChild = ExprToAST(expression->right);
        return bin;
    }
}

// token type checking function used for clarity 
bool checkTokenType(token_t* token, token_type_t requiredType){
    return token->type == requiredType;
}

// gets the next token, saves EOL information and handles scanner status
void nextToken(token_t* token){
    eolCheck = false;
    int status = get_token(token);
    if(checkTokenType(token, token_eol)){
        nextToken(token);
        eolCheck = true;
    }else if((token->type == token_keyword && token->value.keyword_name == keyword_nil)){
        token->type = token_nil; // bypassing older implementation
    }
    if(status!=0){
        exit(status);
    }
}

// verifies expression only valid tokens
bool isExprValid(token_t* token){
    return(token->type <= 13 || token->type == token_identifier 
                           || token->type == token_double 
                           || token->type == token_int 
                           || token->type == token_exp_number
                           || token->type == token_string
                           || token->type == token_nil);
}

// checks if token is identifier or alike
bool isIDVal(token_t* token){
    return (   token->type == token_identifier 
            || token->type == token_double 
            || token->type == token_int 
            || token->type == token_exp_number
            || token->type == token_string);
}

// is of type Type
bool checkType(token_t* token){
    if( token->type == token_keyword && (
        token->value.keyword_name == keyword_Double ||
        token->value.keyword_name == keyword_Int ||
        token->value.keyword_name == keyword_String )){
            return true;
    }
    return false;
}

// : Type
bool checkTokenAssignment(token_t* token){
    if(token->type != token_colon){
        return false;
    }
    nextToken(token);
    return checkType(token);
}

// exits if invalid ID
void checkIdentifier(token_t* token){
    if(token->type != token_identifier){
        exit(SYNTAX_ERROR);
    }
}

// checks ->  &&  Type
void checkReturnType(token_t* token){
    // ->
    bool check = false;
    check = checkTokenType(token, token_minus);
    nextToken(token);

    check = checkTokenType(token, token_greater);
    
    if(check == false){
        exit(SYNTAX_ERROR);
    }

    nextToken(token);

    if(!checkType(token)){
        exit(SYNTAX_ERROR);
    }
}

// check if 'return' is present
void checkReturn(token_t* token){
    // is return?
    if(token->type != token_keyword || token->value.keyword_name != keyword_return){
         exit(SYNTAX_ERROR);
    }
    nextToken(token); 
}

// adds AST node to the end of the linked list of specified AST root
void addToEndOfList(AST** list, AST* node){
    if(*list == NULL){
        *list = node;
        return;
    }
    // top pointer
    AST* current = *list;
    // go through list till the end
    while(current->next != NULL){
        current = current->next;
    }
    // insert last node
    current->next = node;
}


// program rule 
// only top-level
void program(token_t* token){
    // if on toplevel, context is toplevel
    while(!checkTokenType(token, token_eof)){
        if(consCheck && !eolCheck){
            // consecutive statements on a line
            exit(2);
        }else{
            consCheck = false;
        }
        currentContext = prog;
        // if function is declare, current context switches to the function
        if(token->type == token_keyword && token->value.keyword_name == keyword_func){
            // create AST node
            AST* func = createFuncDec();
            currentContext = func;
            nextToken(token); // skip func
            checkIdentifier(token); // is identifier valid?
            // set func ID in AST
            func->data.declaration_func.id = token->value.string_value;
            char *func_id = token->value.string_value;
            // Check if function is already defined
            if(st_search_id_defined(global_symtable, func_id)) {
                exit(SEMANTIC_ERROR_UNDEFINED_FUNCTION);
            }
            int function_type = token_nil;
            nextToken(token); // skip id
            scope_counter++; // increase scope
            st_init(&local_symtable);
            dll_insert_after(symtable_list, local_symtable);
            dll_next(symtable_list); // Local symtable is now the active symtable
            func->data.declaration_func.params = arguments(token);
            bool nullable = false;
            nextToken(token); // skip ) 
            // checking return type
            if(!checkTokenType(token, token_left_curly_bracket)){
                checkReturnType(token);
                // set return type to AST
                if(token->value.keyword_name == keyword_Int){
                    func->data.declaration_func.returnType = INT;
                }else if(token->value.keyword_name == keyword_String){
                    func->data.declaration_func.returnType = STRING;     
                }else{
                    func->data.declaration_func.returnType = DOUBLE;
                }

                function_type = token->value.keyword_name;

                nextToken(token); // skip Type
                if(checkTokenType(token, token_question_mark)){
                    nullable = true;
                    nextToken(token); // skip Type
                }
                if(token->type != token_left_curly_bracket){
                    exit(SYNTAX_ERROR);
                }
            }
            
        
            nextToken(token); // skip {
            st_datatype_t datatype = get_datatype(function_type, nullable);
            st_insert(&global_symtable, func_id, ST_TYPE_FUNCTION, ST_SCOPE_GLOBAL, true, false, datatype, number_params, NULL);
            number_params = 0; // Reset number of parameters 
            if(datatype == ST_DATATYPE_VOID) {
                returnCheck = true;
            }


            // Ast list should be inserted while looping through body
            body(token, true, true); 
            nextToken(token); // skip } 
            scope_counter--; // decrease scope
            st_dispose(&local_symtable); // dispose local symtable
            dll_previous(symtable_list); // previous symtable is now the active symtable
            dll_delete_after(symtable_list); // delete symtable that is after active symtable

            addToEndOfList(&prog->data.program.statements, func);
            if(!returnCheck) {
                exit(SEMANTIC_ERROR_RETURN_FUNCTION);
            }
            returnCheck = false;

            consCheck = true;
        }else{
            body(token, false, false);
        }
    }
}


// body rule
void body(token_t* token, bool expectBrace, bool inFunc){
    do{
        if(consCheck && !eolCheck){
            // consecutive statements on a line
            exit(2);
        }else{
            consCheck = false;
        }
        AST* astNode = malloc(sizeof(AST));

        // call, assignment or expression
        if(token->type != token_keyword){
            if(token->type == token_identifier){
                // in swift  single ID or numerical is valid (only warning)
                // for now I assume it being an error

                char *var_id = token->value.string_value; // save id
                // check id validity
                checkIdentifier(token);
                // save token for further use (id)

                token_t* newToken = malloc(sizeof(token_t)); ;
                
                *newToken = *token;
                nextToken(token);
                
                // check if call 
                if(token->type == token_left_parenthesis){
                    // Search in symtable if that function exists
                    if(!st_search_id_defined(global_symtable, newToken->value.string_value)) {
                        exit(SEMANTIC_ERROR_UNDEFINED_FUNCTION);
                    }          
                    // newToken contains ID
                    AST* params = parameters(token);
                    // Check if number of function params and args are the same
                    if(!st_search_function_pararms(global_symtable, newToken->value.string_value, arg_counter)) {
                        exit(SEMANTIC_ERROR_BAD_TYPE_OPERANDS);
                    }

                    // create func call AST
                    astNode = createFunc(newToken->value.string_value, params, false);
                    
                    nextToken(token); // skip )
                    arg_counter = 0; // Reset number of arguments
                }else if(token->type == token_assign){
                    // save nextoken as ID
                    nextToken(token); // skip = 

                    // invalid assign handler
                    if(!isExprValid(token) && !checkTokenType(token, token_left_parenthesis)){
                        exit(SYNTAX_ERROR);
                    }

                    Expr expre = expression(token, NULL, false); // solve expr
                    AST* expression_semantic = ExprToAST(expre);

                    astNode = malloc(sizeof(AST));
                    astNode->type = EXPRESSION;
                    astNode->data.expression.op = token_assign;

                    AST* lit = malloc(sizeof(AST));
                    lit->type = LITERAL;
                    lit->data.literal.type = ID;
                    lit->data.literal.stringValue = newToken->value.string_value;

                    astNode->data.expression.leftChild = lit;
                    astNode->data.expression.rightChild = ExprToAST(expre);

                    // Semantic check
                    bool is_mutable = dll_is_id_mutable(symtable_list->active, var_id); // False -> let, True -> var
                    bool is_defined = dll_is_id_defined(symtable_list->active, var_id); // False -> not defined, True -> defined
                    // If it is let, and it is defined -> error
                    if(!is_mutable && is_defined) {
                         exit(9);
                    }
                    // Check expression semantic
                    if(expre != NULL) {            
                        // Get the type of the variable
                        st_datatype_t datatype = dll_get_id_type(symtable_list->active, var_id);
                        if(datatype == ST_DATATYPE_UNKNOWN) {
                            exit(3);
                        }
                        if(expre->isFunc) {
                            // Search in symtable if that function exists
                            if(!st_search_id_defined(global_symtable, expre->token.value.string_value)) {
                                exit(SEMANTIC_ERROR_UNDEFINED_FUNCTION);
                            }
                            semantic_expression(expression_semantic, datatype, symtable_list->active);
                        }
                        else {
                            // Find it in dll list, if the variable exists
                            if(!dll_is_id_exist(symtable_list->active, var_id)) {
                                exit(SEMANTIC_ERROR_UNDEFINED_VARIABLE);
                            }
                            semantic_expression(expression_semantic, datatype, symtable_list->active);  
                        }
                        // removes old symbol from symtable
                        st_delete(&symtable_list->active->root, var_id);
                        int var_type = is_mutable ? keyword_var : keyword_let;
                        add_symbol_to_table(symtable_list, datatype, true, var_type, var_id, scope_counter, 0);

                    }
                }else{
                    // unassigned expression statement
                    if(!isExprValid(token) && !checkTokenType(token, token_left_parenthesis)){
                        exit(SYNTAX_ERROR);
                    }
                    
                    Expr expre = expression(token, newToken, false);
                    astNode = ExprToAST(expre);

                    st_datatype_t datatype = expression_get_type(astNode, symtable_list->active);
                    semantic_expression(astNode, datatype, symtable_list->active);
                }
                // consecutive statements check
                consCheck = true;
            }else{
                // prevents inf loop
                if(!checkTokenType(token, token_right_curly_bracket)){
                    exit(2);
                }
            }
        }else if(token->value.keyword_name == keyword_if){
            nextToken(token); // skip if
            // condition = Expression | Let 'Declaration' (Let _) && optional (= ID)
            AST* condition;
            if(checkTokenType(token, token_keyword) && token->value.keyword_name == keyword_let){
                nextToken(token); // skip let
                checkIdentifier(token);
                condition = createVar(LET_DECLARATION, token->value.string_value, NIL, NULL, false);
                nextToken(token); // skip id
            }else{
                // prevents possible segfault
                if(!isExprValid(token) && !checkTokenType(token, token_left_parenthesis)){
                    exit(SYNTAX_ERROR);
                }

                Expr expre = expression(token, NULL, false); // condition

                condition = ExprToAST(expre);
            }
           
            if(token->type != token_left_curly_bracket){
                exit(SYNTAX_ERROR);
            }
            nextToken(token); // skip {
            
            scope_counter++; // increase scope
            st_init(&local_symtable);
            dll_insert_after(symtable_list, local_symtable);
            dll_next(symtable_list); // Local symtable is now the active symtable

            astNode = createIf(condition, NULL, NULL);
            AST* saveContext = currentContext;
            currentContext = astNode;
            // handles IF body
            body(token, true, inFunc);
            currentContext = saveContext;
            nextToken(token); // skip }

            scope_counter--; // decrease scope
            st_dispose(&local_symtable); // dispose local symtable
            dll_previous(symtable_list); // previous symtable is now the active symtable
            dll_delete_after(symtable_list); // delete symtable that is after active symtable
            
            // else
            if(checkTokenType(token, token_keyword) && token->value.keyword_name == keyword_else){
                nextToken(token); // skip else
                if(token->type != token_left_curly_bracket){
                    exit(SYNTAX_ERROR);
                }
                // can be on one line, thus prevent wrong error
                consCheck = false;
                nextToken(token); // skip {
                
                scope_counter++; // increase scope
                st_init(&local_symtable);
                dll_insert_after(symtable_list, local_symtable);
                dll_next(symtable_list); // Local symtable is now the active symtable
                
                // empty {}
                if(checkTokenType(token,token_right_curly_bracket)){
                    astNode->data.astIf.astElse = NULL;
                }else{
                    AST* els = createProgram();
                    AST* saveContext = currentContext;
                    currentContext = els;
                    body(token, true, inFunc);
                    currentContext = saveContext;
                    astNode->data.astIf.astElse = els->data.program.statements;
                }

                nextToken(token); // skip }
                
                scope_counter--; // decrease scope
                st_dispose(&local_symtable); // dispose local symtable
                dll_previous(symtable_list); // previous symtable is now the active symtable
                dll_delete_after(symtable_list); // delete symtable that is after active symtable
            }else{
                exit(2);
            }
            // consecutive statements check
            consCheck = true;
        }else if(token->value.keyword_name == keyword_while){
            nextToken(token); // skip while
            //paranthesis are optional
            if(!isExprValid(token) && !checkTokenType(token, token_left_parenthesis)){
                exit(SYNTAX_ERROR);
            }

            Expr expre = expression(token, NULL, false); // condition

            astNode = createWhile(ExprToAST(expre), NULL);

            if(token->type != token_left_curly_bracket){
                exit(SYNTAX_ERROR);
            }
            nextToken(token); // skip {
            
            scope_counter++; // increase scope
            st_init(&local_symtable);
            dll_insert_after(symtable_list, local_symtable);
            dll_next(symtable_list); // Local symtable is now the active symtable


            AST* saveContext = currentContext;
            currentContext = astNode;
            body(token, true, inFunc);
            currentContext = saveContext;
            nextToken(token); // skip }
            
            scope_counter--; // decrease scope
            st_dispose(&local_symtable); // dispose local symtable
            dll_previous(symtable_list); // previous symtable is now the active symtable
            dll_delete_after(symtable_list); // delete symtable that is after active symtable

            // consecutive statements check
            consCheck = true;
        }else if(token->value.keyword_name == keyword_let || token->value.keyword_name == keyword_var){ // seems like syntax-wise let/var are the same
            Type astType = token->value.keyword_name == keyword_let ? LET_DECLARATION : VAR_DECLARATION;

            int token_mutable = token->value.keyword_name == keyword_let ? keyword_let : keyword_var; // is it let or var
            int token_type; // is it Int, Double or String
            nextToken(token); // skip let/var
            checkIdentifier(token);
            char* id = token->value.string_value;
            nextToken(token); // skip id 
            // is optional 
            bool optional = false;
            litType type = NIL;
            bool nullable = false;
            // ': Type'   check
            if(checkTokenAssignment(token)){
                // if it wasnt assignment keep current token else get new one
                if(token->value.keyword_name == keyword_Int){
                    type = INT;
                }else if(token->value.keyword_name == keyword_String){
                    type = STRING;
                }else if(token->value.keyword_name == keyword_Double){
                    type = DOUBLE;
                }

                token_type = token->value.keyword_name; // save type

                nextToken(token); // skip Type
                if(checkTokenType(token, token_question_mark)){
                    nullable = true;
                    nextToken(token);
                }
                optional = true;
            }

            // is '='? 
            Expr expre = NULL;
            AST* exprAST = NULL;
            bool defined = false;
            if(token->type == token_assign){
                nextToken(token); // skip =
                expre = expression(token, NULL, false);
                exprAST = ExprToAST(expre);
            
            }else if(!optional){ 
                exit(SYNTAX_ERROR);
            }

            astNode = createVar(astType, id, type, exprAST, nullable);

            // Semantic check //
            if(exprAST != NULL) {
                defined = true;
            }
            if(optional) {
                st_datatype_t datatype = get_datatype(token_type, nullable);
                if (defined) {
                    if(exprAST->type == EXPRESSION) {
                        semantic_expression(exprAST, datatype, symtable_list->active);
                    }
                    else if (exprAST->type == FUNC_CALL) {
                        if(!st_search_id_defined(global_symtable, exprAST->data.declaration_func.id)) {
                            exit(SEMANTIC_ERROR_UNDEFINED_FUNCTION);
                        }
                        semantic_expression(exprAST, datatype, symtable_list->active);
                    }
                    else {
                        semantic_handler(datatype, exprAST, symtable_list->active);
                    }
                }        
                add_symbol_to_table(symtable_list, datatype, defined, token_mutable, id, scope_counter, number_params);
            }
            else {
                if(expre != NULL) {
                    if (expre->token.type == token_string || expre->token.type == token_double || expre->token.type == token_int){
                        token_type = expre->token.type;
                        st_datatype_t datatype = get_datatype(token_type, nullable);
                        add_symbol_to_table(symtable_list, datatype, defined, token_mutable, id, scope_counter, number_params);
                    }
                    else{
                        st_datatype_t datatype;
                        if(expre->isFunc) {
                            if(!st_search_id_defined(global_symtable, exprAST->data.declaration_func.id)) {
                                exit(SEMANTIC_ERROR_UNDEFINED_FUNCTION);
                            }
                            datatype = dll_get_id_type(symtable_list->active, exprAST->data.declaration_func.id);
                            if(datatype == ST_DATATYPE_VOID) {
                                exit(7);
                            }
                            semantic_expression(exprAST, datatype, symtable_list->active);
                        }
                        else if (expre->isE) {
                            datatype = expression_get_type(exprAST, symtable_list->active);
                            if (datatype == ST_DATATYPE_UNKNOWN) {
                                exit(SEMANTIC_ERROR_UNDEFINED_VARIABLE);
                            }
                            semantic_expression(exprAST, datatype, symtable_list->active);  
                        }
                        else if (expre->token.type == token_identifier) {
                            datatype = dll_get_id_type(symtable_list->active, expre->token.value.string_value);
                            semantic_handler(datatype, exprAST, symtable_list->active);
                        }
                        add_symbol_to_table(symtable_list, datatype, defined, token_mutable, id, scope_counter, number_params);
                    }
                }
                else {
                    exit(SEMANTIC_ERROR_BAD_VAR_TYPE);
                }
            }
            // consecutive statements check
            consCheck = true;
        }else if(token->value.keyword_name == keyword_return){
            if(!inFunc){
                // return is present outside of function -> error
                exit(SYNTAX_ERROR);
            }

            nextToken(token); // skip 'return'

            if(isExprValid(token)){
                Expr expre = expression(token, NULL, false);
                astNode = createReturn(ExprToAST(expre));
                // Semantic check //
                AST* exprAST = ExprToAST(expre);
                litType func_type = currentContext->data.declaration_func.returnType;
                int token_type = get_type_from_litType(func_type);
                st_datatype_t datatype_func = get_datatype(token_type, false); // Get function ID type
                semantic_return(datatype_func, exprAST, symtable_list->active); // It can be LITERAL, EXPRESSION, but skip FUNC_CALL
                returnCheck = true;
                // Consecutive statements check
                consCheck = true; 
            }

           
        }else{
            //prevents possible inf loop
            exit(2);
        }

        if(currentContext->type == FUNC_DECLARATION){
            addToEndOfList(&currentContext->data.declaration_func.body, astNode);
        }else if(currentContext->type == PROGRAM){
            addToEndOfList(&currentContext->data.program.statements, astNode);
        }else if(currentContext->type == WHILE){
            addToEndOfList(&currentContext->data.astWhile.body, astNode);
        }else if(currentContext->type == IF){
            addToEndOfList(&currentContext->data.astIf.body, astNode);
        }
        
        if(!expectBrace){
            break;
        }

    } while (!checkTokenType(token, token_right_curly_bracket));
    
}

// param rule
// returns list of parameters as AST 
AST* parameters(token_t* token){
    
    // loop  id/expressions/calls  and commas
    if(!checkTokenType(token, token_left_parenthesis)){
        exit(SYNTAX_ERROR);
    }

    nextToken(token);
    if(checkTokenType(token, token_right_parenthesis)){ // ) calls the end of parameters, this solves possible issue with empty call
        return NULL; 
    }

    // ast struct for list of params (top pointer)
    AST* params = NULL;
    // constructs a list with ->next
    AST* currentParam = NULL;
    AST* exprAST = NULL;
    
    // to check named parameters
    token_t* newToken = malloc(sizeof(token_t)); 
    *newToken = *token;
    nextToken(token);
    char* namedParam = NULL;

    while(1){
        // id or expr or fc call
        // i will evaluate all parameters to E -> run it all through Expression parser

        // validity check
        if(isExprValid(newToken) || checkTokenType(newToken, token_left_parenthesis)){
            if(checkTokenType(newToken, token_identifier) && checkTokenType(token, token_colon)){
                namedParam = newToken->value.string_value;
                nextToken(token); // skip :
                if(isExprValid(token)){
                    exprAST = ExprToAST(expression(token, NULL, false));
                }else{
                    exit(SYNTAX_ERROR);
                }
            }else{
                exprAST = ExprToAST(expression(token, newToken, false));
            }

            if(params == NULL){
                params = createParameters(exprAST);
                if(namedParam!= NULL){
                    params->data.astParameter.name = namedParam;
                }

                currentParam = params;
            }else{
                currentParam->next = createParameters(exprAST);
                if(namedParam!= NULL){
                    currentParam->next->data.astParameter.name = namedParam;
                }
                currentParam = currentParam->next;
            }
        }else{ // invalid expression -> error
            exit(SYNTAX_ERROR);
        }
        arg_counter++; // Increase number of arguments
        if(!checkTokenType(token, token_comma)){
            break;
        }

        nextToken(token);
        *newToken = *token;
        nextToken(token);
    }

    // check ending
    if(checkTokenType(token, token_right_parenthesis)){
        return params;
    }
    exit(SYNTAX_ERROR);
}

// argument rule
AST* arguments(token_t* token){
    if(!checkTokenType(token, token_left_parenthesis)){
        exit(SYNTAX_ERROR);
    }

    nextToken(token);  // skip (
    // check if arguments is empty
    if(checkTokenType(token, token_right_parenthesis)){
        return NULL;
    }

    // ast struct for list of params (top pointer)
    // constructs a list with ->next

    AST* temp = createArguments();
    AST* topParam = temp;

    int keyword_type;
    st_datatype_t datatype;

    while(1){
        // id or _ 
        if(token->type == token_keyword && token->value.keyword_name == keyword_underscore){
            temp->data.astArgument.name = NULL;
            // is _ -> valid
        }else{
            checkIdentifier(token); // paramName ir paramId
            temp->data.astArgument.name = token->value.string_value;
        }
        nextToken(token);
        if(checkTokenType(token, token_identifier) || (token->type == token_keyword && token->value.keyword_name == keyword_underscore)){ // if next is ID
            // (param id)
            if( (token->type == token_keyword && token->value.keyword_name == keyword_underscore)){
                temp->data.astArgument.id = "_";
            }else{
                checkIdentifier(token);
                temp->data.astArgument.id = token->value.string_value;
            }
            
            nextToken(token);
        }else{
            exit(2);
        }

        // : Type
        if(!checkTokenAssignment(token)){
            exit(SYNTAX_ERROR);
        }
      
        if(token->value.keyword_name == keyword_Int){
            temp->data.astArgument.type = INT;
        }else if(token->value.keyword_name == keyword_String){
            temp->data.astArgument.type = STRING;
        }else if(token->value.keyword_name == keyword_Double){
            temp->data.astArgument.type = DOUBLE;
        }
        keyword_type = token->value.keyword_name;
        bool nullable = false;
        nextToken(token); // skip Type
        if(checkTokenType(token, token_question_mark)){
            nullable = true;
            temp->data.astArgument.nullable = true;
            nextToken(token);
        }
        datatype = get_datatype(keyword_type, nullable);
        
        number_params++;
        // There need to add to local symtable
        add_symbol_to_table(symtable_list, datatype, true, keyword_let, temp->data.astArgument.id, 1, 0);


        // if not comma, then exit loop
        if(!checkTokenType(token, token_comma)){
            break;
        }
        temp->next = createArguments();
        temp = temp->next;
        // skip ,
        nextToken(token);
    }
    // check ending
    if(checkTokenType(token, token_right_parenthesis)){
        return topParam;
    }
    exit(SYNTAX_ERROR);
    // loop ids and commas
}

// expression rule
//  priorT for functions with lookahead
Expr expression(token_t* token, token_t* priorT, bool expectBrace){
    // lookahead resolve
    token_t* priorToken;
    if(priorT == NULL){
        priorToken = malloc(sizeof(token_t));
        *priorToken = *token;
        nextToken(token);
    }else{
        priorToken = priorT;
    }
    
    // user for handling (E) fc(x..n)
    Expr currentExpression = NULL;
    Stack stack = createStack(10);

    if(priorToken->type != token_identifier 
        && priorToken->type != token_double 
        && priorToken->type != token_int 
        && priorToken->type != token_exp_number
        && priorToken->type != token_string
        && priorToken->type != token_left_parenthesis
        && priorToken->type != token_nil) {
            exit(SYNTAX_ERROR);
    }
    
    while(1){
        if(!isExprValid(priorToken)){
            if(expectBrace == true && !checkTokenType(priorToken, token_left_parenthesis)){
                exit(SYNTAX_ERROR);
            }

            if(checkTokenType(priorToken, token_left_parenthesis)){
                currentExpression = expression(token, NULL, true);
                
                nextToken(token);

                push(stack, currentExpression);

                if(!isExprValid(token) || isIDVal(token)){
                    break;
                }
                *priorToken = *token;
                nextToken(token);

                continue;
            }
            
            if(expectBrace == true && checkTokenType(priorToken, token_right_parenthesis))
            {
                nextToken(token);
            }
            break;
        }
        
        // check functionCalls
        // function calls are wrapped into expression and treated as Identifiers
        if(checkTokenType(priorToken, token_identifier) && checkTokenType(token, token_left_parenthesis)){
            AST* params = parameters(token);
            arg_counter = 0; // Reset number of arguments after function parameters
            nextToken(token); // skip )

            Expr e = createExpr(*priorToken);
            e->isFunc = true;
            e->params = params;

            resolveExpression(stack, e); // should save the call into priorT
            
            if(!isExprValid(token) || isIDVal(token)){
                break;
            }
            
            *priorToken = *token;
            nextToken(token);
            continue;
        }


        resolveExpression(stack, createExpr(*priorToken));

        if(!isExprValid(token) && !checkTokenType(token, token_left_parenthesis)){
            break;
        }

        if(isIDVal(priorToken) && isIDVal(token)){
            if(eolCheck == false){
                exit(SYNTAX_ERROR);
            }
            break;
        }

        *priorToken = *token;
        nextToken(token);
    }

    while (stack->top != 0){
        applyRule(stack);
    }

    return getTop(stack);
}

int main(){
    set_file(stdin);
    if((prog = createProgram())==NULL){
        exit(INTERNAL_ERROR);
    }

    token_t* token = malloc(sizeof(token_t));
    if (token == NULL) {
         printf("Error allocating memory\n");
         exit(INTERNAL_ERROR);
     }
    construct_token(token);

    // Invalid input from scanner or empty program
    nextToken(token);
    // Start -> first rule program

    // Init symtable
    st_init(&global_symtable);
    st_fill_functions(&global_symtable); // This is must have operation

    // Init list 
    symtable_list = (dl_list_t*)malloc(sizeof(dl_list_t));
    dll_init(symtable_list);
    // Add global symtable to list
    dll_insert_first(symtable_list, global_symtable);
    dll_first(symtable_list); // Set global symtable as current

    
    program(token);

    initGenerator(prog);
    //st_inorder(global_symtable);
    
    // Dispose symtable
    st_dispose(&global_symtable);
    dll_delete_first(symtable_list); // Delete global symtable from list
    dll_dispose(symtable_list); // Dispose list

    exit(0);
}