#/**
# * The C Programming Language
# * ==========================
# * 
# * 1st Project
# * Example: A
# * File: Makefile
# * CC: gcc 9.4.0
# * 
# * Author: David Kvacek
# * Login: xkvace00; FIT
# * Date: 2022-03-23
# */

LC_ALL=cs_CZ.utf8
CC=gcc
CFLAGS=-O2 -g -std=c11 -pedantic -Wall -Wextra

.PHONY: all run clean

all: primes primes-i steg-decode

run: primes primes-i steg-decode
	ulimit -s unlimited && time ./primes
	ulimit -s unlimited && time ./primes-i
	./steg-decode du1-obrazek.ppm

clean:
	rm -f primes primes-i steg-decode *.o


primes: bitset.o eratosthenes.o error.o primes.o
	$(CC) $(CFLAGS) -lm bitset.o eratosthenes.o error.o primes.o -o primes

primes-i: bitset-i.o eratosthenes-i.o error.o primes-i.o
	$(CC) $(CFLAGS) -lm bitset-i.o eratosthenes-i.o error.o primes-i.o -o primes-i

steg-decode: bitset.o eratosthenes.o error.o ppm.o steg-decode.o
	$(CC) $(CFLAGS) -lm bitset.o eratosthenes.o error.o ppm.o steg-decode.o -o steg-decode


bitset.o: bitset.c
	$(CC) $(CFLAGS) -c bitset.c -o bitset.o

eratosthenes.o: eratosthenes.c
	$(CC) $(CFLAGS) -c eratosthenes.c -o eratosthenes.o

error.o: error.c
	$(CC) $(CFLAGS) -c error.c -o error.o

ppm.o: ppm.c
	$(CC) $(CFLAGS) -c ppm.c -o ppm.o

primes.o: primes.c
	$(CC) $(CFLAGS) -c primes.c -o primes.o

steg-decode.o: steg-decode.c
	$(CC) $(CFLAGS) -c steg-decode.c -o steg-decode.o


bitset-i.o: bitset.c
	$(CC) $(CFLAGS) -DUSE_INLINE -c bitset.c -o bitset-i.o

eratosthenes-i.o: eratosthenes.c
	$(CC) $(CFLAGS) -DUSE_INLINE -c eratosthenes.c -o eratosthenes-i.o

primes-i.o: primes.c
	$(CC) $(CFLAGS) -DUSE_INLINE -c primes.c -o primes-i.o
