#
# @file Makefile
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
# @brief Makefile for the FLP course functional project.
# @date 2025-03-29
#

BIN = flp-fun
SRC = flp-fun.hs
GHC = ghc
FLAGS = -Wall

.PHONY: all $(BIN) clean

all: $(BIN)

$(BIN): $(SRC)
	$(GHC) $(FLAGS) -o $(BIN) $(SRC)

clean:
	rm -f $(BIN) *.o *.hi
