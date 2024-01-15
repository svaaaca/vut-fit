/*** 
 * @file scanner.h
 * @brief Header file for scanner.c
 * @author Assatulla Dias
 * @author David Kvaček
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


#ifndef __SCANNER_H__
#define __SCANNER_H__
#define __REALLOC_SIZE__ 8

typedef enum {
    STATE_START = 1,


    STATE_DIV, // / or // or /*
    STATE_ONE_LINE_COMMENT, // '//'
    STATE_MULTI_LINE_COMMENT, // '/*'
    STATE_MULTI_LINE_COMMENT_END, // '*', but not the last one

    STATE_LESS, // < or <= // Added to scanner.c
    STATE_GREATER, // > or >= // Added to scanner.c

    STATE_ASSIGN, // = or == // Added to scanner.c
    STATE_NOT_EQUAL, // ! or != // Added to scanner.c
    STATE_UNAR_OPERATOR, // ? or ?? // Added to scanner.c

    STATE_IDENTIFIER, // identifier

    STATE_NUMBER, // number 
    STATE_NUMBER_EXP, // number in exp format
    STATE_NUMBER_EXP_SIGN, // number in exp format with + or -
    STATE_NUMBER_EXP_NUMBER, // number in exp format with number
    STATE_NUMBER_DOT, // number with dot "123."
    STATE_DOUBLE, // double number

    STATE_STRING, // string 
    STATE_EMPTY_OR_MULTI_STRING, // emtpy "" or beginng of multi string"""
    STATE_STRING_ESCAPE_MULTI, // escape sequence in multi string
    STATE_MULTI_STRING, // multi string
    STATE_STRING_MULTI_START, // statrted """ in multi string
    STATE_STRING_START, // started " in string
    STATE_STRING_END, // ended " in string
    STATE_STRING_ESCAPE, // escape sequence in string
    STATE_STRING_ESCAPE_HEX, // escape sequence hex \u
    STATE_STRING_ESCAPE_HEX_1, // escape sequence in \u{
    STATE_STRING_ESCAPE_HEX_2, // escape sequence in \u{d
    STATE_STRING_ESCAPE_HEX_END, // escape sequence in \u{dd}
    STATE_STRING_ESCAPE_HEX_MULTI, // escape sequence hex \u in multi string
    STATE_STRING_ESCAPE_HEX_MULTI_1, // escape sequence in \u{
    STATE_STRING_ESCAPE_HEX_MULTI_2, // escape sequence in \u{d
    STATE_STRING_ESCAPE_HEX_MULTI_END, // escape sequence in \u{dd} in multi string

    STATE_END

} FSM_state_t;

typedef enum {

    token_mul,                  // * 0 
    token_div,                  // / 1
    token_plus,                  // + 2
    token_minus,                  // - 3
    token_dot,                  // . 4

    token_less,                 // < 5
    token_less_equal,           // <= 6
    token_greater,              // > 7
    token_greater_equal,        // >= 8

    token_equal,                // == 9 
    token_not_equal,            // != 10
    token_assign,               // = 11
    token_nil_unar_operator,    // ?? 12
    token_exclamation_mark,     // ! 13

    token_left_parenthesis,     // ( 14
    token_right_parenthesis,    // ) 15
    token_left_curly_bracket,   // { 16
    token_right_curly_bracket,  // } 17
    
    token_comma,                // , 18
    token_colon,                // : 19

    token_keyword,              // keyword  20
    token_identifier,           // identifier 21 // It can be var name or function name
    token_eof,                  // end of file 22
    token_eol,                  // end of line 23

    token_double,               // any float number 24 
    token_int,                  // any int number 25 
    token_string,               // any string 26 
    token_nil,                  // nil 27 

    token_exp_number,           // idk 28 This might be useless :D 

    token_empty,

    token_question_mark,        // ? 29

} token_type_t;


typedef enum {

    keyword_Double,
    keyword_else,
    keyword_if,
    keyword_Int,
    keyword_func,
    keyword_let,
    keyword_nil,
    keyword_return,
    keyword_String,
    keyword_var,
    keyword_while, // Total 11 keywords
    keyword_underscore, // _ 12

} keyword_t;


typedef union {

    double double_value;
    int int_value;
    char *string_value;
    keyword_t keyword_name;

} token_value_t;


// This struct is helper for string
typedef struct string {
    int length;
    char *str;
    int realloc_size;

} string_t;

typedef struct {

    token_type_t type; // Token type. For example token_mul, token_div, token_plus etc
    token_value_t value; // Token value

} token_t;


/****
 * @brief Scans token
 * @param token pointer to token
 * @return SUCCESS if token is legit, otherwice returns LEXICAL_ERROR or INTERNAL_ERROR
*/
int get_token(token_t *token);

/****
 * @brief Free's helper strings
 * @param string_t pointer to string 
 * @return void
*/
void free_strings(string_t *str1);

/***
 * @brieft Adds char to string
 * @param string_t pointer 
 * @param char chr
 * @return SUCCESS if char is added, otherwice returns INTERNAL_ERROR
*/
int add_char_to_str(string_t *string, char chr);


/***
 * @brief Checks if string is keyword
 * @param char pointer
 * @param token_t pointer
 * @return void
*/
void check_keyword(char *string, token_t *token);

/***
 * @brief Add string to token
 * @param token_t pointer
 * @param char pointer
*/
void add_string_to_token(token_t *token, char *string);

/***
 * @brief Function, that checks if the type is correct after ending in ? (Int?, String?, Double?)
 * @param char pointer
 * @param token_t pointer
 * @return SUCCESS if type is correct, otherwice Lexical error
*/
int check_type(char *string, token_t *token);

/***
 * @brief Function, that converts from string to int
 * @param char pointer
 * @param token_t pointer
 * @return void
*/
void from_string_to_int(token_t *token, char *string);

/***
 * @brief Function, that converts from string to double
 * @param char pointer
 * @param token_t pointer
*/
void from_string_to_double(token_t *token, char *string);

/**
 * @brief Function, that constructs a token
 * @param token_t pointer
 * @return void
*/
void construct_token(token_t *token);

/**
 * @brief Function, that sets file input
 * @param FILE pointer
 * @return void
*/
void set_file(FILE *file);
#endif