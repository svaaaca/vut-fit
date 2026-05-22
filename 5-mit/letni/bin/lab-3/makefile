CXXFLAGS=--std=c++14 -Wall -O3 -march=native
HEADERS=${wildcard *.hpp}

.PHONY=clean
all: ca-majority

ca-majority: ca-majority.cpp ${HEADERS}
	${CXX} ${CXXFLAGS} ca-majority.cpp -o $@

clean:
	rm ca-majority
