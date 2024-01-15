/**
 * @file error.h
 * @author Assatulla Dias (xassat00@stud.fit.vutbr.cz)
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Header file for the error codes.
 * @date 2023-10-22
*/

#ifndef __ERROR_H__
#define __ERROR_H__

#define SUCCESS 0                             // Success
#define LEXICAL_ERROR 1                       // Lexical error
#define SYNTAX_ERROR 2                        // Syntax error
#define SEMANTIC_ERROR_UNDEFINED_FUNCTION 3   // Semantic error - undefined function
#define SEMANTIC_ERROR_BAD_TYPE_OPERANDS 4    // Semantic error - bad count/type parameters in function call or bad return type of function
#define SEMANTIC_ERROR_UNDEFINED_VARIABLE 5   // Semantic error - undefined variable
#define SEMANTIC_ERROR_RETURN_FUNCTION 6      // Semantic error - missing return expression from the function
#define SEMANTIC_ERROR_MATH_TYPE 7            // Semantic error - bad type of operands in math expression
#define SEMANTIC_ERROR_BAD_VAR_TYPE 8         // Semantic error - the type of variable or parameter is not specified
#define SEMANTIC_ERROR_OTHERS 9               // Semantic error - other semantic errors
#define INTERNAL_ERROR 99                     // Internal error

#endif
