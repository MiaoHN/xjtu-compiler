CC      = g++
INCLUDE = -Iinclude
TARGET  = semant.out
CFLAGS = -g -Wall -Wno-unused -DDEBUG -Wno-deprecated

all: $(TARGET)

example/symtab_example.o: example/symtab_example.cc
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $^

example: example/symtab_example.o
	$(CC) $(CFLAGS) $(INCLUDE) example/symtab_example.cc -o example.out

SRC = $(wildcard ./src/*.cc)
OBJS = ${SRC:.cc=.o}

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

%.o:%.cc
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $^

test: $(TARGET) test/good.cl test/bad.cl
	@rm -f *.output
	@echo "\e[32;1mTest good.cl...\e[33;0;m"
	@../bin/reference-lexer test/good.cl | ../bin/reference-parser | ./$(TARGET) > good.output ; [ $$? -ge 0 ]
	@echo "\e[32;1mTest bad.cl...\e[33;0;m"
	@../bin/reference-lexer test/bad.cl | ../bin/reference-parser | ./$(TARGET) > bad.output; [ $$? -ge 0 ]
	@echo "\e[32;1mDone.\e[33;0;m"

clean:
	rm -f *.out $(OBJS) *.output
