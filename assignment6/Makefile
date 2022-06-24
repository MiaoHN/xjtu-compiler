CC = g++
CFLAGS = -g -Wall ${CPPINCLUDE}
FLEX = flex ${FFLAGS}
BISON = bison ${BFLAGS}

LEXER = ../bin/reference-lexer

INCLUDE = -I./include
LIBS = -lfl

CSRC = $(wildcard ./src/*.cc)

CGEN = cool-parse.cc
HGEN = cool-parse.h

CFIL = ${CSRC} ${CGEN}
OBJS = ${CFIL:.cc=.o}

TARGET = myparser.out

all: $(TARGET)

$(TARGET): ${OBJS}
	$(CC) $(CFLAGS) $(OBJS) ${LIBS} -o $(TARGET)

%.o:%.cc
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $^ $(LIBS)

test: $(TARGET)
	rm -f *.output
	$(LEXER) test/good.cl | ./$(TARGET) > good.output 2>&1
	$(LEXER) test/bad.cl | ./$(TARGET)  > bad.output  2>&1

cool-parse.cc cool-parse.h: yacc/cool.y
	bison -d -v -y -b cool --debug -p cool_yy yacc/cool.y
	mv -f cool.tab.c cool-parse.cc

clean:
	@rm -f $(TARGET) $(OBJS) $(CGEN) $(HGEN)
