/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: B
 * File: error.h
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#ifndef ERROR_H
#define ERROR_H

void warning_msg(const char * fmt, ...);
void error_exit(const char * fmt, ...);

#endif
