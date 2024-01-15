/**
 *  Implementation of generator
 * File: generator.c
 * 
 * @author Tomas Sedo
 * 
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#include "generator.h"

int isStringEmpty(const char* str) {
    return (strlen(str) == 0);
}

st_node_t *globalSymtable = NULL;
dl_list_t *symtableList;
st_node_t *localSymtable = NULL; // If we see {, we initialize local symtable and if we see }, we dispose it
int scopeCounter = 0;
int frameCounter = 0;

//---------------------------Helper functions---------------------------

//Function for clearing frames where going into different scope
void cleanFrames(){
    for(int i = 0; i < frameCounter; i++){
        printf("PUSHFRAME\n");
    }
    frameCounter = 0;
}

//Function for returning current scope for usage in printing in format scope@varname
const char* getScope(char *key){
    st_node_t *root;
    st_node_t *active;
    dll_get_active(symtableList, &root);
    dll_get_active(symtableList, &active);
    
    st_scope_t scope = ST_SCOPE_UNKNOWN;
    while(scope == ST_SCOPE_UNKNOWN){
        
        if(symtableList->active == NULL){
            
            return "UNEXPECTED";
        }
        
        scope = st_get_id_scope(active, key);
       
        switch(scope){
        case ST_SCOPE_GLOBAL:
            for(int i = 0; i < frameCounter; i++){
                dll_next(symtableList);
            }
            frameCounter = 0;
            return "GF";
            break;
        case ST_SCOPE_LOCAL:
            for(int i = 0; i < frameCounter; i++){
                printf("POPFRAME\n");
                dll_next(symtableList);
            }
            return "LF";
            break;
        case ST_SCOPE_TEMPORARY:
            for(int i = 0; i < frameCounter; i++){
                printf("POPFRAME\n");
                dll_next(symtableList);
            }
            dll_set(symtableList, root);
            return "TF";
            break;
        default:
            break;
        }

        // havent found in current scope, search previous
        dll_previous(symtableList);
        dll_get_active(symtableList, &active);
        frameCounter++;
    }
    return "";
}

//Function that returns Type of the ID
const char* getType(char * key){

    if(strcmp(getScope(key), "GF") == 0){
        st_node_t *root = getGlobalSymtable();
        st_datatype_t type = st_get_id_type(root, key);

        switch(type){
            case ST_DATATYPE_INT:
                return "int";
                break;
            case ST_DATATYPE_STRING:
                return "string";
                break;
            case ST_DATATYPE_DOUBLE:
                return "double";
                break;
            case ST_DATATYPE_INT_NIL:
                return "int_nil";
                break;
            case ST_DATATYPE_DOUBLE_NIL:
                return "double_nil";
                break;
            case ST_DATATYPE_STRING_NIL:
                return "string_nil";
                break;
            default:
                return "unknown";
                break;
        }
    }
    else{
        st_node_t *root;
        dll_get_active(symtableList, &root);
        st_datatype_t type = st_get_id_type(root, key);
        switch(type){
            case ST_DATATYPE_INT:
                return "int";
                break;
            case ST_DATATYPE_STRING:
                return "string";
                break;
            case ST_DATATYPE_DOUBLE:
                return "double";
                break;
            case ST_DATATYPE_INT_NIL:
                return "int_nil";
                break;
            case ST_DATATYPE_DOUBLE_NIL:
                return "double_nil";
                break;
            case ST_DATATYPE_STRING_NIL:
                return "string_nil";
                break;
            default:
                return "unknownos";
                break;
        }
    }
}

//Function for changing certain ascii numbers to format \xyz where xyz is ascii number
char* correctString(char* string){
    char* corrected_string = (char*)malloc(strlen(string) * 4 + 1);
    int j = 0;
    for(int i = 0; i < strlen(string); i++){
        if(string[i] <= 32 || string[i] == 35 || string[i] == 92){
            if(string[i] < 10){
                char buffer[5];
                snprintf(buffer, sizeof(buffer), "\\00%d", string[i]);
                strcat(corrected_string, buffer);
                j += strlen(buffer);
            }
            else{
                char buffer[5];
                snprintf(buffer, sizeof(buffer), "\\0%d", string[i]);
                strcat(corrected_string, buffer);
                j += strlen(buffer);
            }
        }
        else{
            corrected_string[j++] = string[i];
        }
    }
    //corrected_string[j] = '\0';  // Null terminate the corrected_string
    return corrected_string;
}

//---------------------------Generator functions---------------------------

// Function for printing the header
void generator_init(){
    printf(".IFJcode23\n");
}

// Function for initilazing generator, function called in parer.c
void initGenerator(AST* root){
    globalSymtable = getGlobalSymtable();
    symtableList = (dl_list_t*)malloc(sizeof(dl_list_t));
    dll_init(symtableList);
    // Add global symtable to list
    dll_insert_first(symtableList, globalSymtable);
    dll_first(symtableList); // Set global symtable as current
    generateCode(root);
}

// Function which takes a statement and will be processed by its type
void generateCode(AST* root){

    switch(root->type){
        case PROGRAM:
            generateProgram(root);
            break;
        case VAR_DECLARATION:
        case LET_DECLARATION:
            generateDeclarationVar(root);
            break;
        case FUNC_DECLARATION:
            generateDeclarationFunc(root);
            break;
        case FUNC_CALL:
            generateFuncCall(root);
            break;
        case EXPRESSION:
            generateAssignment(root);
            break;
        case LITERAL:
            generateLiteral(root);
            //printf("literal\n");
            break;
        case IF:
            generateIf(root);
            break;
        case WHILE:
            generateWhile(root);
            break;
        case RETURN:
            generateReturn(root);
            break;
        case PARAMETERS:
            generateArgs(root);
            break;
        case ARGUMENT:
            generateParams(root);
            break;
        default:
            break;
    }
}

//Function which prints the header and goes through every line of the code
void generateProgram(AST* program){
    generator_init();
    AST* statement = program->data.program.statements;
    while (statement != NULL){
        generateCode(statement);
        statement = statement->next;
    }
}

// Function for declared variables through var and let as those does not differentiate when generating code
// In case the variable is declared (something is assigned to it) and its type is EXPRESSION then it will go to generateExpression so we can keep
// the name of the variable as parameter of the said function, otherwise it can go through main generateCode function
// If var is in some scope than it has to be put in local symtable
void generateDeclarationVar(AST* declaration_var) {
    if(scopeCounter!=0){
        st_datatype_t datatype;
        switch (declaration_var->data.declaration_var.type)
        {
        case INT:
            datatype = ST_DATATYPE_INT;
            break;
        case DOUBLE:
            datatype = ST_DATATYPE_DOUBLE;
            break;
        case STRING:
            datatype = ST_DATATYPE_STRING;
            break;
        case ID:
            datatype = ST_DATATYPE_STRING;
        default:
            break;
        }
        
        add_symbol_to_table(symtableList, datatype, true, keyword_var, declaration_var->data.declaration_var.id, scopeCounter, 0);
    }    

    printf("DEFVAR %s@%s\n", getScope(declaration_var->data.declaration_var.id), declaration_var->data.declaration_var.id);
    cleanFrames();
    if (declaration_var->data.declaration_var.declaration != NULL) {
        if(declaration_var->data.declaration_var.declaration->type == EXPRESSION)
        {
            generateExpression(declaration_var->data.declaration_var.declaration, declaration_var->data.declaration_var.id);

        }
        else if(declaration_var->data.declaration_var.declaration->type == FUNC_CALL)
        {
            if(strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "ord") == 0 ||
                strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "chr") == 0 ||
                strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "length") == 0 ||
                strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "substring") == 0){
                    generateFuncCallString(declaration_var->data.declaration_var.declaration, declaration_var->data.declaration_var.id);
            }

            else if(strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "Int2Double") == 0 ||
                    strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "Double2Int") == 0){
                generateFuncCallConversion(declaration_var->data.declaration_var.declaration, declaration_var->data.declaration_var.id);
            }

            else if(strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "readString") == 0 ||
                    strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "readInt") == 0 ||
                    strcmp(declaration_var->data.declaration_var.declaration->data.func.id, "readDouble") == 0){
                generateFuncCallRead(declaration_var->data.declaration_var.declaration, declaration_var->data.declaration_var.id);
            }

            else{
                generateCode(declaration_var->data.declaration_var.declaration);
                printf("POPS %s@%s\n", getScope(declaration_var->data.declaration_var.id), declaration_var->data.declaration_var.id);
                cleanFrames();
            }
        }
        else
        {
            generateCode(declaration_var->data.declaration_var.declaration);
            printf("POPS %s@%s\n", getScope(declaration_var->data.declaration_var.id), declaration_var->data.declaration_var.id);
            cleanFrames();
        }   
    }
    else{
        if(strcmp(getType(declaration_var->data.declaration_var.id), "int_nil") == 0 ||
            strcmp(getType(declaration_var->data.declaration_var.id), "double_nil") == 0 ||
            strcmp(getType(declaration_var->data.declaration_var.id), "string_nil") == 0){
            printf("PUSHS nil@nil\n");
            printf("POPS %s@%s\n", getScope(declaration_var->data.declaration_var.id), declaration_var->data.declaration_var.id);
            cleanFrames();
        }
    }
}

//Function that generates user created and prints all the necessary stuff like params 
//and then we will take care of the function body
void generateDeclarationFunc(AST* declaration_func) {
    // Generate code for function declaration
    printf("JUMP %send\n", declaration_func->data.declaration_func.id);
    printf("LABEL %s\n", declaration_func->data.declaration_func.id);
    scopeCounter++;
    st_init(&localSymtable);
    dll_insert_after(symtableList, localSymtable);
    dll_next(symtableList); // Local symtable is now the active symtable
    printf("CREATEFRAME\n");
    printf("PUSHFRAME\n");

    AST* params = declaration_func->data.declaration_func.params;
    while (params != NULL) {
        // Handle each parameter
        generateCode(params);
        params = params->next;
    }

    AST* body_stmt = declaration_func->data.declaration_func.body;
    while (body_stmt != NULL) {
        // Handle each parameter
        generateCode(body_stmt);
        body_stmt = body_stmt->next;
    }
    
    // Generate code for the function body
    printf("POPFRAME\n");
    scopeCounter--; // decrease scope
    st_dispose(&localSymtable); // dispose local symtable
    dll_previous(symtableList); // previous symtable is now the active symtable
    dll_delete_after(symtableList); // delete symtable that is after active symtable
    printf("RETURN\n");
    printf("LABEL %send\n", declaration_func->data.declaration_func.id);
}

//Function tht calls user created and built in functions with all the args
//Built in functions are handled separately, here we handle write function
void generateFuncCall(AST* func_call) {
    // Generate code to evaluate and push arguments onto the stack
    if (strcmp(func_call->data.func.id, "write") == 0){
        AST* args = func_call->data.func.args;

        while (args != NULL) {
            //printf("WRITE");
            //generateCode(args);

            if(args->data.astParameter.expr->data.literal.type == STRING){
                printf("WRITE string@");
                for(int i = 0; i < strlen(args->data.astParameter.expr->data.literal.stringValue); i++){
                    if( args->data.astParameter.expr->data.literal.stringValue[i] <= 32  || 
                        args->data.astParameter.expr->data.literal.stringValue[i] == 35 ||
                        args->data.astParameter.expr->data.literal.stringValue[i] == 92)
                    {
                        if(args->data.astParameter.expr->data.literal.stringValue[i] < 10){
                            printf("\\00%d", args->data.astParameter.expr->data.literal.stringValue[i]);
                        }else{
                            printf("\\0%d", args->data.astParameter.expr->data.literal.stringValue[i]);
                        }
                    }else{
                        printf("%c", args->data.astParameter.expr->data.literal.stringValue[i]);
                    }
                   
                }
                printf("\n");
            }

            else if(args->data.astParameter.expr->data.literal.type == DOUBLE){
                printf("WRITE float@%a\n", args->data.astParameter.expr->data.literal.doubleValue);
            }

            else if(args->data.astParameter.expr->data.literal.type == INT){
                printf("WRITE int@%d\n", args->data.astParameter.expr->data.literal.intValue);
            }

            else if(args->data.astParameter.expr->data.literal.type == ID){
                printf("WRITE %s@%s\n", getScope(args->data.astParameter.expr->data.literal.stringValue), args->data.astParameter.expr->data.literal.stringValue);
                cleanFrames();
            }

            else if(args->data.astParameter.expr->data.literal.type == NIL){
                printf("WRITE GF@%s\n", args->data.astParameter.expr->data.literal.stringValue);
            }

            else{
                printf("WRITE ");
            }
            args = args->next;
        }
    }

    else{
        AST* args = func_call->data.func.args;
        if(args != NULL){
            generateReverseArgs(args);
        }

        // Make the function call
        printf("CALL %s\n", func_call->data.func.id);
        
    }

    
    //if (func_call->data.declaration_func.returnType != NIL) {
        // Generate code to handle the return value
        //printf("MOVE LF@result %s\n", /* Register or variable where the return value is stored */)
    //}
}

//Function for reversing args when calling the function so the right value is assigned to right parameter of the function
void generateReverseArgs(AST* args){
    if(args->next != NULL){
        AST* arg = args->next;
        generateReverseArgs(arg);
    }
    generateCode(args);
}   

// Function for handling built in string function
// ord, chr, length, substring
void generateFuncCallString(AST* func_call, char* var_name){
    if(strcmp(func_call->data.func.id, "ord") == 0){
        AST* args = func_call->data.func.args;

        if(args->data.astParameter.expr->data.literal.type == STRING){
            printf("PUSHS string@%s\n", args->data.astParameter.expr->data.literal.stringValue);
            printf("PUSHS int@0\n");
            printf("STRI2INTS\n");
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames();
            printf("CLEARS\n");
            
        }

        else if(args->data.astParameter.expr->data.literal.type == ID && strcmp(getType(args->data.astParameter.expr->data.literal.stringValue), "string") == 0){
            printf("PUSHS %s@%s\n", getScope(args->data.astParameter.expr->data.literal.stringValue), args->data.astParameter.expr->data.literal.stringValue);
            cleanFrames();
            printf("PUSHS int@0\n");
            printf("STRI2INTS\n");
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames(); 
            printf("CLEARS\n");
        }
    }

    else if(strcmp(func_call->data.func.id, "chr") == 0){
        AST* args = func_call->data.func.args;

        if(args->data.astParameter.expr->data.literal.type == INT){
            printf("PUSHS int@%d\n", args->data.astParameter.expr->data.literal.intValue);
            printf("INT2CHARS\n");
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames(); 
            printf("CLEARS\n");
        }

        else if(args->data.astParameter.expr->data.literal.type == ID && strcmp(getType(args->data.astParameter.expr->data.literal.stringValue), "int") == 0){
            printf("PUSHS %s@%s\n", getScope(args->data.astParameter.expr->data.literal.stringValue), args->data.astParameter.expr->data.literal.stringValue);
            cleanFrames(); 
            printf("INT2CHARS\n");
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames(); 
            printf("CLEARS\n");
        }
    }

    else if(strcmp(func_call->data.func.id, "length") == 0){
        AST* args = func_call->data.func.args;

        if(args->data.astParameter.expr->data.literal.type == STRING){
            printf("STRLEN %s@%s %s@%s\n", getScope(var_name), var_name, "string", args->data.astParameter.expr->data.literal.stringValue);
            cleanFrames(); 
        }

        else if(args->data.astParameter.expr->data.literal.type == ID && strcmp(getType(args->data.astParameter.expr->data.literal.stringValue), "string") == 0){
            printf("STRLEN %s@%s %s@%s\n", getScope(var_name), var_name, getScope(args->data.astParameter.expr->data.literal.stringValue), args->data.astParameter.expr->data.literal.stringValue);
        }
    }

    else if(strcmp(func_call->data.func.id, "substring") == 0){
        AST* args = func_call->data.func.args;
        AST* first_arg = args;
        args = args->next;
        AST* second_arg = args;
        args = args->next;
        AST* third_arg = args;
            
        if(first_arg->data.astParameter.expr->data.literal.type == STRING){
            int string_length = strlen(first_arg->data.astParameter.expr->data.literal.stringValue);

            if(second_arg->data.astParameter.expr->data.literal.type == INT){

                if(third_arg->data.astParameter.expr->data.literal.type == INT){

                    if(second_arg->data.astParameter.expr->data.literal.intValue < third_arg->data.astParameter.expr->data.literal.intValue){
                        printf("DEFVAR GF@random_var_for_substring_built_in_function\n");
                        printf("MOVE %s@%s string@\n", getScope(var_name), var_name);
                        cleanFrames(); 
                        
                        if(second_arg->data.astParameter.expr->data.literal.intValue < 0){
                            printf("PUSHS nil@nil\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }

                        if(second_arg->data.astParameter.expr->data.literal.intValue >= string_length){
                            printf("PUSHS nil@nil\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }

                        if(third_arg->data.astParameter.expr->data.literal.intValue > string_length){
                            printf("PUSHS nil@nil\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }

                        if(!(second_arg->data.astParameter.expr->data.literal.intValue >= string_length) &&
                            !(third_arg->data.astParameter.expr->data.literal.intValue > string_length) &&
                            !(second_arg->data.astParameter.expr->data.literal.intValue < 0)){
                            for(int i = second_arg->data.astParameter.expr->data.literal.intValue; i < third_arg->data.astParameter.expr->data.literal.intValue; i++){
                                printf("GETCHAR GF@random_var_for_substring_built_in_function %s@%s %s@%d\n", "string", first_arg->data.astParameter.expr->data.literal.stringValue, "int", i);
                                printf("CONCAT %s@%s %s@%s GF@random_var_for_substring_built_in_function\n", getScope(var_name), var_name, getScope(var_name), var_name);
                            }
                        }
                    }

                    else if(second_arg->data.astParameter.expr->data.literal.intValue == third_arg->data.astParameter.expr->data.literal.intValue){

                        if(second_arg->data.astParameter.expr->data.literal.intValue >= string_length){
                            printf("PUSHS nil@nil\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }

                        if(third_arg->data.astParameter.expr->data.literal.intValue > string_length){
                            printf("PUSHS nil@nil\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }

                        if(second_arg->data.astParameter.expr->data.literal.intValue < 0){
                            printf("PUSHS nil@nil\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }
                        if(!(second_arg->data.astParameter.expr->data.literal.intValue >= string_length) &&
                            !(third_arg->data.astParameter.expr->data.literal.intValue > string_length) &&
                            !(second_arg->data.astParameter.expr->data.literal.intValue < 0)){
                            printf("PUSHS string@\n");
                            printf("POPS %s@%s\n", getScope(var_name), var_name);
                            cleanFrames(); 
                            printf("CLEARS\n");
                        }
                    }

                    else if(second_arg->data.astParameter.expr->data.literal.intValue > third_arg->data.astParameter.expr->data.literal.intValue){
                        printf("PUSHS nil@nil\n");
                        printf("POPS %s@%s\n", getScope(var_name), var_name);
                        cleanFrames(); 
                        printf("CLEARS\n");
                    }

                }
            }
        }
        
    }
}

// Function for generating built in conversion functions
// Int2Double, Double2Int
void generateFuncCallConversion(AST* func_call, char* var_name){
    if(strcmp(func_call->data.func.id, "Int2Double") == 0){
        AST* args = func_call->data.func.args;

        if(args->data.astParameter.expr->data.literal.type == INT){
            printf("INT2FLOAT %s@%s %s@%d\n", getScope(var_name), var_name, "int", args->data.astParameter.expr->data.literal.intValue);
            cleanFrames(); 
        }
        else if(args->data.astParameter.expr->data.literal.type == ID && strcmp(getType(args->data.astParameter.expr->data.literal.stringValue), "int") == 0){
            printf("INT2FLOAT %s@%s %s@%s\n", getScope(var_name), var_name, getScope(args->data.astParameter.expr->data.literal.stringValue), args->data.astParameter.expr->data.literal.stringValue);
        }
    }

    if(strcmp(func_call->data.func.id, "Double2Int") == 0){
        AST* args = func_call->data.func.args;

        if(args->data.astParameter.expr->data.literal.type == DOUBLE){
            printf("FLOAT2INT %s@%s %s@%a\n", getScope(var_name), var_name, "float", args->data.astParameter.expr->data.literal.doubleValue);
            cleanFrames(); 
        }
        else if(args->data.astParameter.expr->data.literal.type == ID && strcmp(getType(args->data.astParameter.expr->data.literal.stringValue), "double") == 0){
            printf("FLOAT2INT %s@%s %s@%s\n", getScope(var_name), var_name, getScope(args->data.astParameter.expr->data.literal.stringValue), args->data.astParameter.expr->data.literal.stringValue);
        }
    }
}

// Function for generating built in  reading functions
// readString, readInt, readDouble
void generateFuncCallRead(AST* func_call, char* var_name){

    if (strcmp(func_call->data.func.id, "readString") == 0){
        printf("READ %s@%s %s\n", getScope(var_name), var_name, "string"); 
        cleanFrames(); 
    }

    else if (strcmp(func_call->data.func.id, "readInt") == 0){
        printf("READ %s@%s %s\n", getScope(var_name), var_name, "int"); 
        cleanFrames(); 
    }

    else if (strcmp(func_call->data.func.id, "readDouble") == 0){
        printf("READ %s@%s %s\n", getScope(var_name), var_name, "float"); 
        cleanFrames(); 
    }
}

// Function for defining parametres of the function
// Similar to generateDeclarationVar function
void generateParams(AST* func_param){
    if(scopeCounter!=0){
        st_datatype_t datatype;
        switch (func_param->data.astArgument.type)
        {
        case INT:
            datatype = ST_DATATYPE_INT;
            break;
        case DOUBLE:
            datatype = ST_DATATYPE_DOUBLE;
            break;
        case STRING:
            datatype = ST_DATATYPE_STRING;
            break;
        case ID:
            datatype = ST_DATATYPE_STRING;
        default:
            break;
        }
        
        add_symbol_to_table(symtableList, datatype, true, keyword_var, func_param->data.astArgument.id, scopeCounter, 0);
    }
    printf("DEFVAR %s@%s\n", getScope(func_param->data.astArgument.id), func_param->data.astArgument.id);
    cleanFrames(); 
    printf("POPS %s@%s\n", getScope(func_param->data.astArgument.id), func_param->data.astArgument.id);
    cleanFrames(); 
}

// Function for generating Args when calling the function
// Pushing to stack depending on the data type, so it can be obtained from stack in the function
void generateArgs(AST* func_args){
    if(func_args->data.astParameter.expr->data.literal.type == INT){
        printf("PUSHS %s@%d\n", "int", func_args->data.astParameter.expr->data.literal.intValue);
    }

    else if(func_args->data.astParameter.expr->data.literal.type == STRING){
        printf("PUSHS %s@%s\n", "string", func_args->data.astParameter.expr->data.literal.stringValue);
    }

    else if(func_args->data.astParameter.expr->data.literal.type == DOUBLE){
        printf("PUSHS %s@%a\n", "float", func_args->data.astParameter.expr->data.literal.doubleValue);
    }

    else if(func_args->data.astParameter.expr->data.literal.type == ID){
        printf("PUSHS %s@%s\n", getScope(func_args->data.astParameter.expr->data.literal.stringValue), func_args->data.astParameter.expr->data.literal.stringValue);
        cleanFrames();    
    }
}

// Generates Return for function and push the value on stack so it can be accessible after the function ends
void generateReturn(AST* func_return){
    //printf("Som tu >D\n");
    if(func_return->data.astReturn.expression->type == EXPRESSION){
        evaluate(func_return->data.astReturn.expression);
    }
    else if(func_return->data.astReturn.expression->type == LITERAL){
        evaluate(func_return->data.astReturn.expression);
    }
}

//Function for generating literals which will be processed by their type
void generateLiteral(AST* literal){
    switch(literal->data.literal.type){
        case INT:
            printf("PUSHS int@%d\n", literal->data.literal.intValue);
            break;
        case DOUBLE:
            printf("PUSHS float@%a\n", literal->data.literal.doubleValue);
            break;
        case NIL:
            printf("PUSHS nil@nil\n");
            break;
        case EXPONENTIONAL:
            break;
        case STRING:
        {
            char* stringos = correctString(literal->data.literal.stringValue);
            printf("PUSHS string@%s\n", stringos);
            free(stringos);
            break;
        }
        case ID:
            printf("PUSHS %s@%s\n", getScope(literal->data.literal.stringValue), literal->data.literal.stringValue);
            cleanFrames();
            break;
        default:
            break;
    }
}

// Function for generating arithmetic logic for ADD, SUB, MUL
// mostly used are stack versions, checking all possible options that can happen
void generateArithmetic(const char *operation, AST* leftChild, AST* rightChild, char *var_name){
    if(leftChild->data.literal.type == ID && rightChild->data.literal.type == ID){

        if(strcmp(getType(leftChild->data.literal.stringValue), "string") == 0 && strcmp(getType(rightChild->data.literal.stringValue), "string") == 0){
            printf("CONCAT %s@%s %s@%s %s@%s\n", getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, getScope(rightChild->data.literal.stringValue),rightChild->data.literal.stringValue);
        }

        else{
        printf("%s %s@%s %s@%s %s@%s\n", operation, getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }
    }

    else if(leftChild->data.literal.type == INT && rightChild->data.literal.type == INT){
        generateCode(leftChild);
        generateCode(rightChild);
        printf("%sS\n", operation);
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == ID && rightChild->data.literal.type == INT){

        if(strcmp(getType(leftChild->data.literal.stringValue), "int") == 0){
            printf("%s %s@%s %s@%s %s@%d\n", operation, getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, "int", rightChild->data.literal.intValue);
        }

        else if(strcmp(getType(leftChild->data.literal.stringValue), "double") == 0){
            printf("PUSHS %s@%s\n", getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue);
            cleanFrames();
            generateCode(rightChild);
            printf("INT2FLOATS\n");
            printf("%sS\n", operation);
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames();
            printf("CLEARS\n");
        }
    }

    else if(leftChild->data.literal.type == INT && rightChild->data.literal.type == ID){

        if(strcmp(getType(rightChild->data.literal.stringValue), "int") == 0){
            printf("%s %s@%s %s@%d %s@%s\n", operation, getScope(var_name), var_name, "int", leftChild->data.literal.intValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }

        else if(strcmp(getType(rightChild->data.literal.stringValue), "double") == 0){
            generateCode(leftChild);
            printf("INT2FLOATS\n");
            printf("PUSHS %s@%s\n", getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
            cleanFrames();
            printf("%sS\n", operation);
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames();
            printf("CLEARS\n");
        }
    }

    else if(leftChild->data.literal.type == DOUBLE && rightChild->data.literal.type == DOUBLE){
        generateCode(leftChild);
        generateCode(rightChild);
        printf("%sS\n", operation);
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == ID && rightChild->data.literal.type == DOUBLE){

        if(strcmp(getType(leftChild->data.literal.stringValue), "double") == 0){
                    printf("%s %s@%s %s@%s %s@%a\n", operation, getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, "float", rightChild->data.literal.doubleValue);
                }

        else if(strcmp(getType(leftChild->data.literal.stringValue), "int") == 0){
            printf("PUSHS %s@%s\n", getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue);
            cleanFrames();
            printf("INT2FLOATS\n");
            generateCode(rightChild);         
            printf("%sS\n", operation);
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames();
            printf("CLEARS\n");
        }    }

    else if(leftChild->data.literal.type == DOUBLE && rightChild->data.literal.type == ID){
        printf("%s %s@%s %s@%a %s@%s\n", operation, getScope(var_name), var_name, "float", leftChild->data.literal.doubleValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
    }

    else if(leftChild->data.literal.type == INT && rightChild->data.literal.type == DOUBLE){
        generateCode(leftChild);
        printf("INT2FLOATS\n");
        generateCode(rightChild);
        printf("%sS\n", operation);
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == DOUBLE && rightChild->data.literal.type == INT){
        generateCode(leftChild);
        generateCode(rightChild);
        printf("INT2FLOATS\n");
        printf("%sS\n", operation);
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == STRING && rightChild->data.literal.type == STRING){
        char* leftString = correctString(leftChild->data.literal.stringValue);
        char* rightString = correctString(rightChild->data.literal.stringValue);
        printf("CONCAT %s@%s %s@%s %s@%s\n", getScope(var_name), var_name, "string", leftString, "string", rightString);
        cleanFrames();
        free(leftString);
        free(rightString);
    }

    else if(leftChild->data.literal.type == ID && rightChild->data.literal.type == STRING){
        char* rightString = correctString(rightChild->data.literal.stringValue);
        printf("CONCAT %s@%s %s@%s %s@%s\n", getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, "string", rightString);
        free(rightString);
    }

    else if(leftChild->data.literal.type == STRING && rightChild->data.literal.type == ID){
        char* leftString = correctString(leftChild->data.literal.stringValue);
        printf("CONCAT %s@%s %s@%s %s@%s\n", getScope(var_name), var_name, "string", leftString, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        free(leftString);
    }

    else{
        printf("Not resolved yet\n");
    }
}

// Function for generating IDIV/DIV
// handles all the cases that can happen
void generateDivision(AST* leftChild, AST* rightChild, char* var_name){

    if(leftChild->data.literal.type == ID && rightChild->data.literal.type == ID){

        if(strcmp(getType(leftChild->data.literal.stringValue), "float") == 0 && strcmp(getType(rightChild->data.literal.stringValue), "float") == 0){
            printf("DIV %s@%s %s@%s %s@%s\n", getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }

        else if(strcmp(getType(leftChild->data.literal.stringValue), "int") == 0 && strcmp(getType(rightChild->data.literal.stringValue), "int") == 0){
            printf("IDIV %s@%s %s@%s %s@%s\n", getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }
    }

    else if(leftChild->data.literal.type == INT && rightChild->data.literal.type == INT){
        generateCode(leftChild);
        generateCode(rightChild);
        printf("IDIVS\n");
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == DOUBLE && rightChild->data.literal.type == DOUBLE){
        generateCode(leftChild);
        generateCode(rightChild);
        printf("DIVS\n");
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == DOUBLE && rightChild->data.literal.type == INT){
        generateCode(leftChild);
        generateCode(rightChild);
        printf("INT2FLOATS\n");
        printf("DIVS\n");
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == INT && rightChild->data.literal.type == DOUBLE){
        generateCode(leftChild);
        printf("INT2FLOATS\n");
        generateCode(rightChild);
        printf("DIVS\n");
        printf("POPS %s@%s\n", getScope(var_name), var_name);
        cleanFrames();
        printf("CLEARS\n");
    }

    else if(leftChild->data.literal.type == ID && rightChild->data.literal.type == INT){
        if(strcmp(getType(leftChild->data.literal.stringValue), "double") == 0){
            printf("PUSHS %s@%s\n", getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue);
            cleanFrames();
            generateCode(rightChild);
            printf("INT2FLOATS\n");
            printf("DIVS\n");
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames();
            printf("CLEARS\n");
        }
        else if(strcmp(getType(leftChild->data.literal.stringValue), "int") == 0){
            printf("IDIV %s@%s %s@%s %s@%d\n", getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, "int", rightChild->data.literal.intValue);
        }
    }

    else if(leftChild->data.literal.type == ID && rightChild->data.literal.type == DOUBLE){
        if(strcmp(getType(leftChild->data.literal.stringValue), "int") == 0){
            printf("PUSHS %s@%s\n", getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue);
            cleanFrames();
            printf("INT2FLOATS\n");
            generateCode(rightChild);
            printf("DIVS\n");
            printf("POPS %s@%s\n", getScope(var_name), var_name);
            cleanFrames();
            printf("CLEARS\n");
        }
        else if(strcmp(getType(leftChild->data.literal.stringValue), "double") == 0){
            printf("DIV %s@%s %s@%s %s@%a\n", getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, "float", rightChild->data.literal.doubleValue);
        }
    }

    else if(leftChild->data.literal.type == DOUBLE && rightChild->data.literal.type == ID){

        if(strcmp(getType(rightChild->data.literal.stringValue), "double") == 0){
            printf("DIV %s@%s %s@%a %s@%s\n", getScope(var_name), var_name, "float", leftChild->data.literal.doubleValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }
    }

    else if(leftChild->data.literal.type == INT && rightChild->data.literal.type == ID){

        if(strcmp(getType(rightChild->data.literal.stringValue), "int") == 0){
            printf("IDIV %s@%s %s@%d %s@%s\n", getScope(var_name), var_name, "int", leftChild->data.literal.intValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }
    }

    else{
        printf("Not resolved yet\n");
    }
}

// Function for generating logic for <, >, ==
// Handles all other stuff, that cannot be handled in generateArithemtic
void generateLogic(const char* operation, AST* leftChild, AST* rightChild, char* var_name){
    if(leftChild->data.literal.type == STRING && rightChild->data.literal.type == STRING){
        printf("%s %s@%s %s@%s %s@%s\n", operation, getScope(var_name), var_name, "string", leftChild->data.literal.stringValue, "string", rightChild->data.literal.stringValue);
    }

    else if(leftChild->data.literal.type == ID && rightChild->data.literal.type == STRING){

        if(strcmp(getType(leftChild->data.literal.stringValue), "string") == 0){
            printf("%s %s@%s %s@%s %s@%s\n", operation, getScope(var_name), var_name, getScope(leftChild->data.literal.stringValue), leftChild->data.literal.stringValue, "string", rightChild->data.literal.stringValue);
        }
    }

    else if(leftChild->data.literal.type == STRING && rightChild->data.literal.type == ID){

        if(strcmp(getType(rightChild->data.literal.stringValue), "string") == 0){
            printf("%s %s@%s %s@%s %s@%s\n", operation, getScope(var_name), var_name, "string", leftChild->data.literal.stringValue, getScope(rightChild->data.literal.stringValue), rightChild->data.literal.stringValue);
        }
    }
}

//Function which processes expressions by their operands, each case of different literal type and different scope is handled too
//DIV and IDIV have to be handled differently because DIV is for FLOAT(double) and IDIV is for INT
void generateExpression(AST* expression, char* var_name){

    AST* leftChild = expression->data.expression.leftChild;
    AST* rightChild = expression->data.expression.rightChild;

    switch(expression->data.expression.op){
        //TODO STACK versions
        // remainder % aka modulo???
        case token_plus:
            generateArithmetic("ADD", leftChild, rightChild, var_name);
            break;

        case token_minus:
            generateArithmetic("SUB", leftChild, rightChild, var_name);
            break;
            
        case token_mul:
            generateArithmetic("MUL", leftChild, rightChild, var_name);
            break;
        case token_div:
            generateDivision(leftChild, rightChild, var_name);
            break;
        // <=, >=, != ???
        case token_less: 
            if(leftChild->data.literal.type == STRING || rightChild->data.literal.type == STRING){
                generateLogic("LT", leftChild, rightChild, var_name);
            }

            else{
                generateArithmetic("LT", leftChild, rightChild, var_name);
            }
            break;
        case token_greater:
            if(leftChild->data.literal.type == STRING || rightChild->data.literal.type == STRING){
                generateLogic("GT", leftChild, rightChild, var_name);
            }

            else{
                generateArithmetic("GT", leftChild, rightChild, var_name);
            }
            break;
        case token_equal:
            if(leftChild->data.literal.type == STRING || rightChild->data.literal.type == STRING){
                generateLogic("EQ", leftChild, rightChild, var_name);
            }

            else{
                generateArithmetic("EQ", leftChild, rightChild, var_name);
            }
            break;
        default:
            printf("WRONG OPERAND");
    }
}

// Function similar to generateExpression
// works almost the same, can handle more complicated problems
void evaluate(AST* root){
    switch (root->type)
    {
    case LITERAL:
        // literals should be pushed to be calculated
        if(root->data.literal.type == 0){
            printf("PUSHS string@%s\n", root->data.literal.stringValue);
        }else if(root->data.literal.type == 1){
            printf("PUSHS double@%a\n", root->data.literal.doubleValue);
        }else if(root->data.literal.type == 2){
            printf("PUSHS int@%d\n", root->data.literal.intValue);
        }else{
            printf("PUSHS %s@%s\n", getScope(root->data.literal.stringValue), root->data.literal.stringValue);
            cleanFrames();
        }
        break;
    case EXPRESSION:
        switch(root->data.expression.op){
            case token_plus:
                evaluate(root->data.expression.leftChild);
                evaluate(root->data.expression.rightChild);
                printf("ADDS\n");
                break;
            case token_minus:
                evaluate(root->data.expression.leftChild);
                evaluate(root->data.expression.rightChild);
                printf("SUBS\n");
                break;
            case token_mul:
                evaluate(root->data.expression.leftChild);
                evaluate(root->data.expression.rightChild);
                printf("MULS\n");
                break;
            case token_div:
                evaluate(root->data.expression.leftChild);
                evaluate(root->data.expression.rightChild);
                printf("DIVS\n");
                break;
            default:
                break;
        }
        break;
    
    default:
        break;
    }
}

//Generates assignment when the var is defined and we want to assign value to it
void generateAssignment(AST* root){
    // if not =, then the expression is valid but not printed as it doesnt evaluate to anything
    // if assigned to a non id, also not evaluated
    if(root->data.expression.op == token_assign && root->data.expression.leftChild->type == LITERAL && root->data.expression.leftChild->data.literal.type == ID){
        //root->data.expression.leftChild->data.literal.stringValue
        evaluate(root->data.expression.rightChild);
        printf("POPS %s@%s\n", getScope(root->data.expression.leftChild->data.literal.stringValue), root->data.expression.leftChild->data.literal.stringValue);
        cleanFrames();
    }
}

int test = 0;
// Function for generating WHILE
// working with frames using dll to switch between them
// using conditional jumps to jump to start and to the end of the while
void generateWhile(AST* root){
    scopeCounter++;
    AST* cond = root->data.astWhile.condition;
    int currentScope = test++;
    printf("LABEL while%d\n", currentScope);
    // generate condition
    // assuming root is comparasion operator 
    switch (cond->data.expression.op)
    {
    case token_greater:
        //printf("DEFVAR TF@conditional\n");
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("GTS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        break;
    case token_less:
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("LTS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        break;
    case token_less_equal:
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("LTS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("EQS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        break;
    case token_greater_equal:
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("GTS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("EQS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        break;
    case token_equal:
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("EQS\nPUSHS bool@true\n");
        printf("JUMPIFNEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        break;
    case token_not_equal:
        evaluate(cond->data.expression.leftChild);
        evaluate(cond->data.expression.rightChild);
        printf("EQS\nPUSHS bool@true\n");
        printf("JUMPIFEQS while%dend\n", currentScope);
        printf("CLEARS\n");
        break;
    
    default:
        return;
    }
    st_init(&localSymtable);
    dll_insert_after(symtableList, localSymtable);
    dll_next(symtableList); // Local symtable is now the active symtable
    printf("CREATEFRAME\n");
    printf("PUSHFRAME\n");
    while(root->data.astWhile.body != NULL){
        generateCode(root->data.astWhile.body);
        root->data.astWhile.body = root->data.astWhile.body->next;
    }
    printf("POPFRAME\n"); 
    printf("JUMP while%d\n", currentScope);
    printf("LABEL while%dend\n", currentScope);

    scopeCounter--; // decrease scope
    st_dispose(&localSymtable); // dispose local symtable
    dll_previous(symtableList); // previous symtable is now the active symtable
    dll_delete_after(symtableList); // delete symtable that is after active symtable
}

// Function for generating IF
// works almost the same way as WHILE
// we have on more label that marks else, so we have start, end and else
void generateIf(AST* root){
    AST* cond = root->data.astIf.condition;
    int currentScope = test++;

    if(cond->type == LET_DECLARATION){
        printf("PUSHS %s@%s\n", getScope(cond->data.declaration_var.id), cond->data.declaration_var.id);
        cleanFrames();
        printf("PUSHS nil@nil\n");
        printf("EQS\nPUSHS bool@true\n");
        if(root->data.astIf.astElse == NULL){
            printf("JUMPIFEQS if%dend\n", currentScope);
        }else{
            printf("JUMPIFEQS if%delse\n", currentScope);
        }
        printf("CLEARS\n");
    }else{
        switch (cond->data.expression.op)
        {
        case token_greater:
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("LTS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("EQS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            break;
        case token_less:
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("GTS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("EQS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            break;
        case token_less_equal:
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("GTS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            break;
        case token_greater_equal:
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("LTS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            break;
        case token_equal:
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("EQS\nPUSHS bool@true\n");
            printf("JUMPIFNEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            break;
        case token_not_equal:
            evaluate(cond->data.expression.leftChild);
            evaluate(cond->data.expression.rightChild);
            printf("EQS\nPUSHS bool@true\n");
            printf("JUMPIFEQS if%delse\n", currentScope);
            printf("CLEARS\n");
            break;
       
        default:
            return;
        }
         
    }
    scopeCounter++;
    st_init(&localSymtable);
    dll_insert_after(symtableList, localSymtable);
    dll_next(symtableList); // Local symtable is now the active symtable
    printf("CREATEFRAME\n");
    printf("PUSHFRAME\n");
    while(root->data.astIf.body != NULL){
        generateCode(root->data.astIf.body);
        root->data.astIf.body = root->data.astIf.body->next;
    }
    printf("POPFRAME\n");
    scopeCounter--; // decrease scope
    st_dispose(&localSymtable); // dispose local symtable
    dll_previous(symtableList); // previous symtable is now the active symtable
    dll_delete_after(symtableList); // delete symtable that is after active symtable
    if(root->data.astIf.astElse != NULL){
        scopeCounter++;
        printf("JUMP if%dend\n", currentScope);
        printf("LABEL if%delse\n", currentScope);
        st_init(&localSymtable);
        dll_insert_after(symtableList, localSymtable);
        dll_next(symtableList); // Local symtable is now the active symtable
        printf("CREATEFRAME\n");
        printf("PUSHFRAME\n");
        while(root->data.astIf.astElse != NULL){
            generateCode(root->data.astIf.astElse);
            root->data.astIf.astElse = root->data.astIf.astElse->next;
        }
        printf("POPFRAME\n");
        scopeCounter--; // decrease scope
        st_dispose(&localSymtable); // dispose local symtable
        dll_previous(symtableList); // previous symtable is now the active symtable
        dll_delete_after(symtableList); // delete symtable that is after active symtable
    }
   
    printf("LABEL if%dend\n", currentScope);


}

