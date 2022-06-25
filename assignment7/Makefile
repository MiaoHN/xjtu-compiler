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

clean:
	rm -f *.out $(OBJS)
