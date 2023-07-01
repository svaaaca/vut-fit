#/**
# * Operating Systems
# * =================
# * 
# * 2nd Project
# * Author: David Kvacek
# * Login: xkvace00; FIT
# * Date: 2022-05-02
# */

CC=gcc
CFLAGS=-std=gnu99 -Wall -Wextra -Werror -pedantic -pthread
PROJ=proj2

.PHONY: all clean

all: $(PROJ)

clean:
	rm -f $(PROJ) *.o *.out

$(PROJ): $(PROJ).c
	$(CC) $(CFLAGS) $(PROJ).c -o $(PROJ)
