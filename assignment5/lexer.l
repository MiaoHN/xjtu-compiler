%{
#include <stdio.h>

typedef union {
  double dval;
  char str[32];
} un;
#define YYSTYPE un
YYSTYPE yylval;

#include "parser.tab.h"

void yyerror(char*);

%}
%%

[0-9]+(\.([0-9]+)?)?    { 
            yylval.dval = atof(yytext); 
            return token_number; 
          }
[=()\-+*/\r\n]  { return *yytext;}
[A-Za-z]* {
            strcpy(yylval.str, yytext);
            return token_symbol; 
          }
[ \t]     ;
.         { yyerror("invalid characters"); }

%%

int yywarp(void) {
  return 1;
}
