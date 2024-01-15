# make run < x.swift 

CC= gcc 
CFLAGS= -pedantic -Wall -g 
LDFLAGS= -lm

SRC= $(shell find -name "*.c")
OBJ= $(addsuffix .o, $(basename $(SRC)))

SRC = scanner.c parser.c expressions.c symtable.c semantics.c generator.c
HDR = scanner.h parser.h cexpressions.h error.h symtable.h semantics.h generator.h # Add your header files here
OBJ = $(SRC:.c=.o)

all: program

run: all
	@./program

program:$(OBJ)
	$(CC) $(CFLAGS) -o  $@ $(OBJ) $(LDFLAGS)
	
clean:
	find -name "*.o" -delete
	rm program
