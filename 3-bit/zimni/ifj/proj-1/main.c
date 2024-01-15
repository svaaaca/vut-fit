#include <stdio.h>
#include "scanner.h"
#include "error.h"

// Before using get_token, you need to create token_t variable and initialize it

int main1() {
    
    // MUST HAVE PROCESS
    token_t *token = malloc(sizeof(token_t));
    if (token == NULL) {
         printf("Error allocating memory\n");
         exit(INTERNAL_ERROR);
     }
    construct_token(token);

    
    set_file(stdin);
    // NOW YOU CAN USE get_token(token)
    while(token->type  != token_eof) {
        if(get_token(token) == 0) {
            if(token->type == token_int) {
                printf("int: %d\n", token->value.int_value);
            }
            else if (token->type == token_double) {
                printf("double: %f\n", token->value.double_value);
            }
            else if (token->type == token_keyword) {
                printf("keyword: %d\n", token->value.keyword_name);
            }
            else if (token->type == token_mul){
                printf("mul\n");
            }
            else if (token->type == token_div){
                printf("div\n");
            }
            else if (token->type == token_keyword) {
                printf("keyword: %d\n", token->value.keyword_name);
            }
            else if (token->type == token_string) { // Has problem with multi string. 
                printf("string: %s\n", token->value.string_value);
            }
            else if (token->type == token_identifier) { 
                printf("identifier: %s\n", token->value.string_value);
            }
            else if (token->type == token_question_mark){
                printf("question_mark\n");
            }
        }
        else {
            printf("Error\n");
        }
    }
    return 0;
}
