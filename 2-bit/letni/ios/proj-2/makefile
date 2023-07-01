# @file makefile
# @author David Kvacek (xkvace00)
# @brief Makefile for the executable file proj2
# @version 1.0
# @date 2023-05-01

NAME=proj2
MAKEFILE=makefile

CC=gcc
CFLAGS=-std=gnu99 -Wall -Wextra -Werror -pedantic
DFLAGS=-pthread -lrt

.PHONY: all run zip clean

all: $(NAME)

$(NAME): $(NAME).c
	$(CC) $(CFLAGS) $(DFLAGS) $(NAME).c -o $(NAME)

run: $(NAME)
	./$(NAME) $(ARGS)

zip: $(NAME).c $(MAKEFILE)
	zip $(NAME).zip $(NAME).c $(MAKEFILE)

clean:
	rm -f $(NAME) $(NAME).out $(NAME).zip
