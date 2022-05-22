CC   = gcc
LEX  = flex

LIBS   = -lfl

all: char_count.out comment_count.out lexc.out
	@echo "\e[32;1mCompile done.\e[33;0;m"

.PHONY: clean

char_count.yy.c: char_count.l
	@$(LEX) -o $@ $<

char_count.out: char_count.yy.c
	@$(CC) -o $@ $< $(LIBS) $(CFLAGS)

comment_count.yy.c: comment_count.l
	@$(LEX) -o $@ $<

comment_count.out: comment_count.yy.c
	@$(CC) -o $@ $< $(LIBS) $(CFLAGS)

lexc.yy.c: lexc.l
	@$(LEX) -o $@ $<

lexc.out: lexc.yy.c
	@$(CC) -o $@ $< $(LIBS) $(CFLAGS)

clean:
	@rm -f *.out
	@rm -f *.yy.c
	@echo "\e[32;1mClean finish\e[33;0;m"
