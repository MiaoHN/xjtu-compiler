CLASSDIR = ~/codes/xjtu-compiler

FILES = $(wildcard *.cl)
OBJS = $(patsubst %.cl, %.s, ${FILES})

all: source test

source:
	@echo "\e[32;1mCompiling...\e[33;0;m"
	@${CLASSDIR}/bin/coolc ${FILES}
	@echo "\e[32;1mCompile OK!\e[33;0;m"

test: source
	@echo "\e[32;1mStart testing...\e[33;0m"
	@${CLASSDIR}/bin/spim -trap_file ${CLASSDIR}/lib/trap.handler -file ${OBJS}
	@echo "\e[32;1mTest finished!\e[33;0m"

clean:
	@rm -f *.s
	@echo "\e[32;1mClean finished!\e[33;0m"
