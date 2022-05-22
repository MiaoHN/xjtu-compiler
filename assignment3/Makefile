CC   = gcc
LEX  = flex

LIBS   = -lfl

all: *.out

.PHONY: clean

*.out: *.c
	$(CC) -o $< $@ $(LIBS) $(CFLAGS)

*.c: *.l
	$(LEX) -o $< $@

clean:
	@rm -f *.out
	@rm -f *.yy.c
	@echo "\e[32;1mClean finish\e[33;0;m"
