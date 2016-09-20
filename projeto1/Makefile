VERSION=v0.2
OUTPUT=lukacompiler

$(OUTPUT): parser.h parser.cpp scanner.cpp main.cpp
	g++ -o $(OUTPUT) *.cpp -std=c++11

parser.h: parser.y
	bison --defines=parser.h -o parser.cpp parser.y

scanner.cpp: parser.h scanner.l
	flex -o scanner.cpp scanner.l

clear:
	rm lukacompiler parser.cpp parser.h scanner.cpp test

test:
	echo "file 1" > test
	-./lukacompiler < tests/$(VERSION)/input/1.in | diff -B - tests/$(VERSION)/expected/1.ex >> test
	echo "file 2" >> test
	-./lukacompiler < tests/$(VERSION)/input/2.in | diff -B - tests/$(VERSION)/expected/2.ex >> test
	echo "file 3" >> test
	-./lukacompiler < tests/$(VERSION)/input/3.in | diff -B - tests/$(VERSION)/expected/3.ex >> test
