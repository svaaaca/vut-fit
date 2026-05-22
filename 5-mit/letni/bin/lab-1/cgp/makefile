all:	cgp.exe

cgp.exe:	cgp.cpp cgp.h data/*.h
		g++ cgp.cpp -O3 -o cgp

clean:
		rm cgp.exe 

cleanlog:
		rm log_*.*

run:	cgp.exe
		cgp.exe