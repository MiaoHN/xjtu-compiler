CLASSDIR = ..
CC 			 = g++
LEX			 = flex
RM 			 = rm -f

INCLUDE  = -I./include
C_SOURCE = $(wildcard ./src/*.cc)
L_SOURCE = $(wildcard ./lex/*.l)
TARGET   = lexer.out
CFLAGS   = -g -Wall -O0

all: compile

compile: lex_compile $(C_SOURCE)
	@echo "\e[32;1mCompiling target...\e[33;0;m"
	@$(LEX) $(L_SOURCE)
	@$(CC) $(C_SOURCE) lex.yy.c $(INCLUDE) -o $(TARGET) $(CFLAGS)
	@echo "\e[32;1mCompile done.\e[33;0;m"

lex_compile: $(L_SOURCE)
	@echo "\e[32;1mCompile lex...\e[33;0;m"
	@$(LEX) $(L_SOURCE)

test: compile
	@./$(TARGET) test/test.cl

check: compile
	@echo "\e[32;1mStart checking...\e[33;0;m"
	@./$(TARGET) test/test.cl > my-lexer.txt
	@../bin/reference-lexer test/test.cl > reference-lexer.txt
	@echo "\e[32;1mmy-lexer                                                      reference-lexer\e[33;0;m"
	@diff -y --suppress-common-lines my-lexer.txt reference-lexer.txt ; [ $$? -eq 1 ]
	@rm my-lexer.txt reference-lexer.txt
	@echo "\e[32;1mCheck done.\e[33;0;m"

clean:
	@$(RM) $(TARGET) *.yy.c 
	@echo "\e[32;1mClean done.\e[33;0;m"