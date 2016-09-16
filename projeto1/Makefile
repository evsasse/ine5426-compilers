OUTPUT=lukacompiler

$(OUTPUT): parser.h parser.cpp scanner.cpp main.cpp
	g++ -o $(OUTPUT) *.cpp -std=c++11

parser.h: parser.y
	bison --defines=parser.h -o parser.cpp parser.y

scanner.cpp: parser.h scanner.l
	flex -o scanner.cpp scanner.l

clear:
	rm lukacompiler parser.cpp parser.h scanner.cpp
