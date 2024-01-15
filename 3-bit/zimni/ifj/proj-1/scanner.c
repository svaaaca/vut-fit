/**
 * @file: scanner.c
 * @author Assatulla Dias (xassat00@stud.fit.vutbr.cz)
 * @brief Implementation of scanner (tokenizer)
*/

#include "scanner.h"
#include "error.h"

#define STRING_MAGIC_NUMBER 16 // Magic number for realloc

FILE *file = NULL; 


void set_file(FILE *f) {
    file = f;
    if (file == NULL) {
        file = stdin;
    }
}

int add_char_to_str(string_t *str, char chr) {
    if(str->length + 1 >= str->realloc_size) {
        str->realloc_size += STRING_MAGIC_NUMBER;
        char *tmp = (char *)realloc(str->str, str->realloc_size);
        if (tmp == NULL) {
            fprintf(stderr, "Internal error: realloc failed");
            exit(INTERNAL_ERROR);
        }
        str->str = tmp;
    }
    str->str[str->length] = chr;
    str->length++;
    str->str[str->length] = '\0';
    return SUCCESS;
}

void check_keyword(char *str, token_t *token) {
    if (strcmp(str, "Double") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_Double;
    }
    else if (strcmp(str, "else") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_else;
    } 
    else if (strcmp(str,"if") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_if;
    }
    else if (strcmp(str, "func") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_func;
    }
    else if (strcmp(str, "Int") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_Int;
    }
    else if (strcmp(str, "let") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_let;
    }
    else if (strcmp(str, "nil") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_nil;
    }
    else if (strcmp(str, "return") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_return;
    }
    else if (strcmp(str, "String") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_String;
    }
    else if (strcmp(str, "var") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_var;
    }
    else if (strcmp(str, "while") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_while;
    }
    else if (strcmp(str, "_") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_underscore;
    }
    else { 
        token->type = token_identifier;
    }
    
} 

void add_string_to_token(token_t *token, char *str) {
    token->value.string_value = (char *)malloc(sizeof(char) * strlen(str));
    if(token->value.string_value == NULL) {
        fprintf(stderr, "Internal error: malloc failed");
        exit(INTERNAL_ERROR);
    }
    strcpy(token->value.string_value, str);
}

void from_string_to_int(token_t *token, char *str) {
    token->value.int_value = atoi(str);
}

void from_string_to_double(token_t *token, char *str) {
    token->value.double_value = atof(str);
}

void free_strings(string_t *str) {
    if(str != NULL && str->str != NULL) {
        free(str->str);
        str->str = NULL;
    }
    if (str != NULL) {
        free(str);
    }
}


int check_type(char *str, token_t *token) {
    if (strcmp(str, "Int") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_Int;
    }
    else if (strcmp(str, "Double") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_Double;
    }
    else if (strcmp(str, "String") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_String;
    }
    else if (strcmp(str, "nil") == 0) {
        token->type = token_keyword;
        token->value.keyword_name = keyword_nil;
    }
    
    if (token->type != token_keyword) return LEXICAL_ERROR;
    return SUCCESS;
}

void construct_token(token_t *token) {
    if (token == NULL) {
        fprintf(stderr, "Internal error: token is NULL");
        exit(INTERNAL_ERROR);
    }
    token->type = token_empty;
    token->value.string_value = NULL;
}

int get_token(token_t *token) {
    
    char chr;
    char ascii_hex[2];
    int state = STATE_START;
    int quot_counter = 0;
    int inner_coments_counter = 0;

    string_t *str = (string_t *)malloc(sizeof(string_t));
    if (str == NULL) {
        fprintf(stderr, "Internal error: malloc failed");
        exit(INTERNAL_ERROR);
    }
    str->str = NULL;
    str->length = 0;
    str->realloc_size = 0;

    
    if (file == NULL) {
        fprintf(stderr, "Internal error: file is NULL");
        exit(INTERNAL_ERROR);
    }

    while(1) {
        chr = fgetc(file);

        switch (state)
        {
        case STATE_START:
            if (chr == ' ' || chr == '\t' || chr == '\r') {
                state = STATE_START;
                break;
            }
            else if (chr == '\n') {
                token->type = token_eol;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == '+') {
                token->type = token_plus;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == '-') {
                token->type = token_minus;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == '*') {
                token->type = token_mul;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == ':') {
                token->type = token_colon;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == ',') {
                token->type = token_comma;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == '{') {
                token->type = token_left_curly_bracket;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == '}') {
                token->type = token_right_curly_bracket;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == '(') {
                token->type = token_left_parenthesis;
                free_strings(str);
                return SUCCESS;
            }
            else if (chr == ')') {
                token->type = token_right_parenthesis;
                free_strings(str);
                return SUCCESS;
            } 

            // States start here
            else if (chr == '>') {
                state = STATE_GREATER;
            }
            else if (chr == '<') {
                state = STATE_LESS;
            }
            else if (chr == '=') {
                state = STATE_ASSIGN;
            }
            else if (chr == '!') {
                state = STATE_NOT_EQUAL;
            }
            else if (chr == '?') {
                state = STATE_UNAR_OPERATOR;
            }
            else if (chr == '/') {
                state = STATE_DIV;
            }

            // character check // 
            else if (isalpha(chr) != 0 || chr == '_') {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }

                state = STATE_IDENTIFIER;
            }

            // Number check //
            else if (isdigit(chr) != 0) {
                if (add_char_to_str(str, chr) != 0) { 
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_NUMBER;
            }

            // String check //
            else if (chr == '\"') {
                quot_counter++; // 1
                state = STATE_STRING;
            }

            else if (chr == EOF) {
                state = STATE_END;
            }

            else {
                fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            
            break;

        case STATE_STRING:
            if (chr == '\"') {
                quot_counter++; // 2
                state = STATE_EMPTY_OR_MULTI_STRING;
            }
            else {
                if (chr == '\\') {
                    state = STATE_STRING_ESCAPE;
                    break;
                }
                else if (chr < 32) {
                    fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                    free_strings(str);
                    exit(LEXICAL_ERROR);
                }

                // add char to string
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_STRING_START;
            }
            break;

        case STATE_EMPTY_OR_MULTI_STRING:
            if (chr == '\"') {
                quot_counter++; // 3 multi string started
                state = STATE_MULTI_STRING;
            }
            else {
                // empty string
                token->type = token_string;
                add_string_to_token(token, "");
                free_strings(str);
                state = STATE_START;
                ungetc(chr, file);
                return SUCCESS;
            }
            break;


        case STATE_MULTI_STRING:
            while(1) {
                if (chr == '\"') {
                    char chr1 = fgetc(file);
                    if (chr1 != '\"' && chr1 != EOF && (quot_counter != 1 && quot_counter != 0)) {
                        add_char_to_str(str, chr);
                        add_char_to_str(str, chr1);
                        while(1) {
                            chr1 = fgetc(file);
                            if (chr1 == '\"') {
                                break;
                            }
                            else {
                                add_char_to_str(str, chr1);
                            }
                        }
                        ungetc(chr1, file);
                        break;
                    }
                    else {
                        ungetc(chr1, file);
                        quot_counter--; // 2
                        if (quot_counter == 0) {
                            state = STATE_STRING_END;
                            break;
                        }
                        else {
                            state = STATE_MULTI_STRING;
                            break;
                        }
                    }
                }
                else if (chr == '\\') {
                    state = STATE_STRING_ESCAPE_MULTI;
                    break;
                }
                else if (chr < 32 && chr != '\n' && chr != '\t' && chr != '\r') {
                    fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                    free_strings(str);
                    exit(LEXICAL_ERROR);
                }
                
                // add char to string
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                chr = fgetc(file);
            }
            break;

        case STATE_STRING_ESCAPE_MULTI:
            if (chr == '\"') {
                state = STATE_MULTI_STRING;
                if(add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 'n') {
                state = STATE_MULTI_STRING;
                if(add_char_to_str(str, '\n') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 'r') {
                state = STATE_MULTI_STRING;
                if(add_char_to_str(str, '\r') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 't') {
                state = STATE_MULTI_STRING;
                if(add_char_to_str(str, '\t') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == '\\') {
                state = STATE_MULTI_STRING;
                if(add_char_to_str(str, '\\') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 'u') { // for \u{dd} where dd is hex number
                state = STATE_STRING_ESCAPE_HEX_MULTI;
            }
            else {
                fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            break;
        case STATE_STRING_ESCAPE_HEX_MULTI:
            if (chr == '{') {
                state = STATE_STRING_ESCAPE_HEX_MULTI_1;
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
        
        case STATE_STRING_ESCAPE_HEX_MULTI_1:
            if((chr >= '0' && chr <= '9') || (chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z')) {
                // adding first d in \u{d      
                state = STATE_STRING_ESCAPE_HEX_MULTI_2;
                ascii_hex[0] = chr;
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
        
        case STATE_STRING_ESCAPE_HEX_MULTI_2:
            if((chr >= '0' && chr <= '9') || (chr >= 'a' && chr <= 'z') || chr >= ('A' && chr <= 'Z')) {
                // adding second d in \u{dd
                state = STATE_STRING_ESCAPE_HEX_MULTI_END;
                ascii_hex[1] = chr;
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }

        case STATE_STRING_ESCAPE_HEX_MULTI_END:
            if (chr == '}') {
                state = STATE_MULTI_STRING;
                add_char_to_str(str, strtol(ascii_hex, NULL, 16));
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }

        case STATE_STRING_START:
            while(1) {
                if (chr == '\"') {
                    state = STATE_STRING_END;
                    break;
                }
                else if (chr == '\\') {
                    state = STATE_STRING_ESCAPE;
                    break;
                }
                else if (chr < 32) {
                    fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                    free_strings(str);
                    exit(LEXICAL_ERROR);
                }
                // add char to string
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                chr = fgetc(file);
            }
            break;

        case STATE_STRING_ESCAPE:
            if (chr == '\"') {
                state = STATE_STRING_START;
                if(add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 'n') {
                state = STATE_STRING_START;
                if(add_char_to_str(str, '\n') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 'r') {
                state = STATE_STRING_START;
                if(add_char_to_str(str, '\r') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 't') {
                state = STATE_STRING_START;
                if(add_char_to_str(str, '\t') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == '\\') {
                state = STATE_STRING_START;
                if(add_char_to_str(str, '\\') != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else if (chr == 'u') { // for \u{dd} where dd is hex number
                state = STATE_STRING_ESCAPE_HEX;
            }
            else if (chr < 32) {
                fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            else {
                state = STATE_STRING_START;
                add_char_to_str(str, '\\');
                add_char_to_str(str, chr);
            }
            break;

        case STATE_STRING_ESCAPE_HEX: // added -> \u 
            if (chr == '{') {
                state = STATE_STRING_ESCAPE_HEX_1;
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }

        case STATE_STRING_ESCAPE_HEX_1: // added -> \u{
            if((chr >= '0' && chr <= '9') || (chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z')) {
                // adding first d in \u{d      
                state = STATE_STRING_ESCAPE_HEX_2;
                ascii_hex[0] = chr;
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }

        case STATE_STRING_ESCAPE_HEX_2: // added -> \u{d
            if((chr >= '0' && chr <= '9') || (chr >= 'a' && chr <= 'z') || chr >= ('A' && chr <= 'Z')) {
                // adding second d in \u{dd
                state = STATE_STRING_ESCAPE_HEX_END;
                ascii_hex[1] = chr;
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }

        case STATE_STRING_ESCAPE_HEX_END:
            if (chr == '}') {
                state = STATE_STRING_START;
                add_char_to_str(str, strtol(ascii_hex, NULL, 16));
                break;
            }
            else {
                fprintf(stderr, "Lexical error: escape sequence of \\u is invalid '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }

        case STATE_STRING_END:
            token->type = token_string;
            add_string_to_token(token, str->str);
            free_strings(str);
            state = STATE_START;
            ungetc(chr, file);
            return SUCCESS;

    // STATE OF NUMBERS STARTS HERE // 
        case STATE_NUMBER:
            if (chr == '.') {
                if (add_char_to_str(str,chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_NUMBER_DOT;
            }
            else if (chr == 'e' || chr == 'E') {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_NUMBER_EXP;
            }
            else { 
                if(isdigit(chr) == 0) { 
                    ungetc(chr, file);
                    from_string_to_int(token, str->str);
                    token->type = token_int;
                    free_strings(str);
                    return SUCCESS;
                }
                else {
                    if (add_char_to_str(str, chr) != 0) {
                        fprintf(stderr, "Internal error: add_char_to_str failed");
                        free_strings(str);
                        exit(INTERNAL_ERROR);
                    }
                }
            }
            break;

        case STATE_NUMBER_DOT:
            if (isdigit(chr) != 0) {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_DOUBLE;
            }
            else {
                fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            break;

        case STATE_DOUBLE:
            if (chr == 'e' || chr == 'E') {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_NUMBER_EXP;
            }
            else  {
                if (isdigit(chr) != 0){
                    if (add_char_to_str(str, chr) != 0) {
                        fprintf(stderr, "Internal error: add_char_to_str failed");
                        free_strings(str);
                        exit(INTERNAL_ERROR);
                    }
                }
                else if (chr == '.') { 
                    fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                    free_strings(str);
                    exit(LEXICAL_ERROR);
                }
                else {
                    ungetc(chr, file);
                    from_string_to_double(token, str->str);
                    token->type = token_double;
                    free_strings(str);
                    return SUCCESS;
                }
            }

            break;

        case STATE_NUMBER_EXP:
            if (chr == '+' || chr == '-') {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_NUMBER_EXP_SIGN;
            }
            else {
                if(isdigit(chr) != 0) { 
                    if (add_char_to_str(str, chr) != 0) {
                        fprintf(stderr, "Internal error: add_char_to_str failed");
                        free_strings(str);
                        exit(INTERNAL_ERROR);
                    }
                    state = STATE_NUMBER_EXP_NUMBER;
                }
                else {
                    fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                    free_strings(str);
                    exit(LEXICAL_ERROR);
                }
            }
            break;
        
        case STATE_NUMBER_EXP_NUMBER:
            if (isdigit(chr) != 0) {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else {
                ungetc(chr, file);
                from_string_to_double(token, str->str);
                token->type = token_double;
                free_strings(str);
                return SUCCESS;
            }
            break;

        case STATE_NUMBER_EXP_SIGN:
            if (isdigit(chr) != 0) {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
                state = STATE_NUMBER_EXP_NUMBER;
            }
            else {
                fprintf(stderr, "Lexical error: unknown character '%c'", chr);
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            break;

    // STATE OF NUMBERS ENDS HERE // 
        case STATE_IDENTIFIER:
            if (isalpha(chr) != 0 || isdigit(chr) != 0 || chr == '_') {
                if (add_char_to_str(str, chr) != 0) {
                    fprintf(stderr, "Internal error: add_char_to_str failed");
                    free_strings(str);
                    exit(INTERNAL_ERROR);
                }
            }
            else {
                ungetc(chr, file);
                check_keyword(str->str, token);
                if (token->type == token_identifier) {
                    add_string_to_token(token, str->str);
                }
                free_strings(str);
                return SUCCESS;
            }
            break;

        // div, or comment /, //, /*
        case STATE_DIV:
            if (chr == '/') {
                state = STATE_ONE_LINE_COMMENT;
            }
            else {
                if (chr == '*'){
                    state = STATE_MULTI_LINE_COMMENT;
                    inner_coments_counter++;
                }
                else {
                    ungetc(chr, file);
                    token->type = token_div;
                    free_strings(str);
                    return SUCCESS;
                }
            }
            break;

        // one line comment
        case STATE_ONE_LINE_COMMENT:
            if (chr == EOF) {
                state = STATE_START;
            }
            else if (chr == '\n') {
                token->type = token_eol;
                free_strings(str);
                return SUCCESS;
            }
            else {
                state = STATE_ONE_LINE_COMMENT;
            }
            break;

        // multi line comment
        case STATE_MULTI_LINE_COMMENT:
            if (chr == EOF) {
                fprintf(stderr, "Lexical error: unexpected EOF");
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            if (chr == '*') {
                state = STATE_MULTI_LINE_COMMENT_END;
            }
            else if (chr == '/') {
                chr = fgetc(file); 
                if (chr == '*') {
                    inner_coments_counter++;
                }
                else {
                    ungetc(chr, file);
                }
            }
            else {
                state = STATE_MULTI_LINE_COMMENT;
            }
            break;

        // multi line comment end 1
        case STATE_MULTI_LINE_COMMENT_END:
            if (chr == EOF) {
                fprintf(stderr, "Lexical error: unexpected EOF");
                free_strings(str);
                exit(LEXICAL_ERROR);
            }
            if (chr == '/') {
                inner_coments_counter--;
                if (inner_coments_counter == 0) {
                    state = STATE_START;
                }
                else {
                    state = STATE_MULTI_LINE_COMMENT;
                }
            }
            else {
                state = STATE_MULTI_LINE_COMMENT;
            }
            break;

        // ??, ?
        case STATE_UNAR_OPERATOR:
            if (chr == '?') {
                token->type = token_nil_unar_operator;
                free_strings(str);
                return SUCCESS;
            }
            else {
                ungetc(chr, file);
                token->type = token_question_mark;
                free_strings(str);
                return SUCCESS;
            }
            break;

        // >=, >
        case STATE_GREATER:
            if (chr == '=') {
                token->type = token_greater_equal;
            }
            else {
                ungetc(chr, file);
                token->type = token_greater;
            }
            free_strings(str);
            return SUCCESS;
            break;

        // <=, <
        case STATE_LESS:
            if (chr == '=') {
                token->type = token_less_equal;
            }
            else {
                ungetc(chr, file);
                token->type = token_less;
            }
            free_strings(str);
            return SUCCESS;
            break;
        
        // ==. =
        case STATE_ASSIGN:
            if (chr == '=') {
                token->type = token_equal;
            }
            else {
                ungetc(chr, file);
                token->type = token_assign;
            }
            free_strings(str);
            return SUCCESS;
            break;

        //  !=, !
        case STATE_NOT_EQUAL:
            if (chr == '=') {
                token->type = token_not_equal;
            }
            else {
                ungetc(chr, file);
                token->type = token_exclamation_mark;
            }
            free_strings(str);
            return SUCCESS;
            break;

        case STATE_END:
            token->type = token_eof;
            free_strings(str);
            return SUCCESS;
            break;
            
        default:
            fprintf(stderr, "Lexical error: unknown chars.");
            free_strings(str);
            exit(LEXICAL_ERROR);
            break;
        }
    }
}