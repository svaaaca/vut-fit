#/**
# * The C Programming Language
# * ==========================
# * 
# * 2nd Project
# * Example: A
# * File: Makefile
# * CC: gcc 9.4.0
# * 
# * Author: David Kvacek
# * Login: xkvace00; FIT
# * Date: 2022-04-20
# */

CC=gcc
CFLAGS=-std=c11 -pedantic -Wall -Wextra

.PHONY: all clean

all: tail

clean:
	rm -f tail *.o

tail: tail.c
	$(CC) $(CFLAGS) tail.c -o tail
