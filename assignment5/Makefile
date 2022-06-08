CC   = gcc
LEX  = flex
YACC = bison

TARGET = calculator

LIBS   = -lfl

all: compile
	@echo "\e[32;1mCompile done.\e[33;0;m"

run: all
	@echo "\e[32;1mStart running...\e[33;0;m"
	@./$(TARGET); [ $$? -ge -1 ]

compile: $(TARGET)

$(TARGET): lex.yy.c parser
	@$(CC) -o $(TARGET) parser.tab.c lex.yy.c $(LIBS)

parser: parser.y
	@$(YACC) -d parser.y

lex.yy.c: lexer.l
	@$(LEX) -o $@ $<

.PHONY: clean

clean:
	@rm -f $(TARGET)
	@rm -f *.h
	@rm -f *.c
	@echo "\e[32;1mClean finish\e[33;0;m"
