%{
#include <stdio.h>

int comments = 0;
int lines = 1;
%}
%x comment c_comment
%%
\n                  { lines++; }
.                   ;
"//"                { BEGIN comment; comments++; }
"/*"                { BEGIN c_comment; comments++; } 
<comment>.          ;
<comment>\n         { BEGIN 0; lines++; }
<c_comment>.        ;
<c_comment>\n       { lines++; }
<c_comment><<EOF>>	{ printf("%d: Untermiated comment.\n",lines);exit(-1);}
<c_comment>"*/"     { BEGIN 0; }
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

  printf("comments: %d, lines: %d\n", comments, lines);
  return 0;
}