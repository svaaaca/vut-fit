#
# @file makefile
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
# @brief Makefile for the IMS course project source code.
# @date 2024-12-02
#

CC = g++
CFLAGS = -std=c++11 -g -O2 -Wall -Wextra -Werror -pedantic
LDFLAGS = -lm -lsimlib
NAME = main

.PHONY: $(NAME) clean run

$(NAME): $(NAME).cc
	$(CC) $(CFLAGS) $(NAME).cc -o $(NAME) $(LDFLAGS)

clean:
	rm -f *.o $(NAME)

run: $(NAME)
	./$(NAME)
