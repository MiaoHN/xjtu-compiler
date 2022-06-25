CC      = g++
INCLUDE = -Iinclude
TARGET  = semant.out
CFLAGS = -g -Wall -Wno-unused -DDEBUG -Wno-deprecated

all: $(TARGET)

example: example/symtab_example.cc
	$(CC) $(CFLAGS) $(INCLUDE) example/symtab_example.cc -o example.out

SRC = $(wildcard ./src/*.cc)
OBJS = ${SRC:.cc=.o}

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

%.o:%.cc
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $^

test: $(TARGET) test/good.cl test/bad.cl
	rm -f *.output
	../bin/reference-lexer test/good.cl | ../bin/reference-parser | ./$(TARGET) > good.output
	../bin/reference-lexer test/bad.cl | ../bin/reference-parser | ./$(TARGET) > bad.output

clean:
	rm -f *.out $(OBJS) *.output
