# @file makefile
# @author David Kvacek (xkvace00)
# @brief Makefile for ipk-sniffer.
# @version 1.0
# @date 2023-04-17

NAME=ipk-sniffer

CC=gcc
CFLAGS=-lpcap

.PHONY: all run clean

all: $(NAME)

$(NAME): $(NAME).c
	$(CC) $(CFLAGS) -o $(NAME) $(NAME).c

run: $(NAME)
	./$(NAME) $(ARGS)

clean:
	rm -f $(NAME)
