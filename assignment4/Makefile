CLASSDIR = ..
CC 			 = g++
LEX			 = flex
RM 			 = rm -f

INCLUDE  = -I./include
C_SOURCE = $(wildcard ./src/*.cc)
L_SOURCE = $(wildcard ./lex/*.l)
TARGET   = lexer.out

all: compile

compile: lex_compile $(C_SOURCE)
	@echo "\e[32;1mCompiling target...\e[33;0;m"
	@$(LEX) $(L_SOURCE)
	@$(CC) $(C_SOURCE) lex.yy.c $(INCLUDE) -o $(TARGET)
	@echo "\e[32;1mCompile done.\e[33;0;m"

lex_compile: $(L_SOURCE)
	@echo "\e[32;1mCompile lex...\e[33;0;m"
	@$(LEX) $(L_SOURCE)

clean:
	@$(RM) $(TARGET) *.yy.c 
	@echo "\e[32;1mClean finish.\e[33;0;m"