# /**
#  * @file makefile
#  * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
#  * @brief Makefile for the implementation of monitoring DHCP communication.
#  * @date 2023-11-20
#  */

NAME = dhcp-stats
CC = gcc
CFLAGS = -std=gnu17 -Wall -Werror -Wextra -pedantic
LIBS = -lpcap -lm -lncurses
LOGIN = xkvace00
FILES = $(NAME).1 $(NAME).c $(NAME).h Makefile manual.pdf README

.PHONY: $(NAME) clean tar

$(NAME): $(NAME).c $(NAME).h
	$(CC) $(CFLAGS) -o $@ $(NAME).c $(LIBS)

clean:
	rm -f $(NAME) $(LOGIN).tar

tar: $(FILES)
	tar -cvf $(LOGIN).tar $(FILES)
