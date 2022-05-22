%{
#include <stdio.h>
int chars = 0;
int words = 0;
int lines = 1;
%}
%%
[ \t]       ;
\n          { ++lines; }
[^ \t\n]+   { ++words; chars += yyleng; }
%%
int main(int argc, char const* argv[]) {
  if (argc == 2) {
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
      printf("can't open %s\n", argv[1]);
      return -1;
    }
  } else {
    printf("usage: %s <file>\n", argv[0]);
    return -1;
  }

  yylex();

  printf("line: %d, word: %d, char: %d\n", lines, words, chars);
  return 0;
}