%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylex();
void yyerror(char*);

typedef union {
  double dval;
  char str[32];
} un;
#define YYSTYPE un
YYSTYPE yylval;

char* symbols[256];
double values[256];
int top = 0;

void add_symbol(const char* symbol, double value);
double get_symbol(const char* symbol);

%}

%union {
   double  dval;
   char str[32];
}

%token <dval> token_number
%token <str> token_symbol

%type <dval> expr
%type <dval> tt
%type <dval> ff

%%

statement : token_symbol '=' expr '\n' { add_symbol($1, $3); }
          | expr '\n'                  { printf("result: %g\n", $1); }
          ;

expr : expr '+' tt { $$ = $1 + $3; }
     | expr '-' tt { $$ = $1 - $3; }
     | tt          { $$ = $1; }
     ;

tt : tt '*' ff { $$ = $1 * $3; }
   | tt '/' ff { $$ = $1 / $3; }
   | ff        { $$ = $1; }
   ;

ff : '(' expr ')' { $$ = $2; }
   | '-' ff       { $$ = -$2; }
   | token_number { $$ = $1; }
   | token_symbol { $$ = get_symbol($1); }
   ;

%%

void add_symbol(const char* symbol, double value) {
  for (int i = 0; i < top; ++i) {
    if (!strcmp(symbols[i], symbol)) {
      values[i] = value;
      return;
    }
  }
  symbols[top] = (char*)malloc(sizeof(char));
  strcpy(symbols[top], symbol);
  values[top] = value;
  top++;
}

double get_symbol(const char* symbol) {
  for (int i = 0; i < top; ++i) {
    if (!strcmp(symbols[i], symbol)) {
      return values[i];
    }
  }
  yyerror("symbol not exist");
  return 0.0;
}

void yyerror(char *str) {
  extern char* yytext;
  if (!strcmp(yytext, "\n")) return;
  printf("Error: %s\n", str);
}

int main() {
  while (1) {
    yyparse();
  }
  return 0;
}
