%{
#include <stdio.h>

int lines = 1;

char *Type[] = {"STRING", "MACRO", "IDENTIFIER", "KEYWORD", "DELIMITER", "OPERATOR", "INTEGER", "ERROR"};

struct Token {
  int type;
  char data[32];
  int lineno;
};

struct Token g_tokens[1024];
int token_len = 0;
%}
%x COMMENT C_COMMENT ERROR_OCCUR
STRING        \".*\"
MACRO         ^#.*\n
ID            [a-zA-Z_]([0-9]|[a-zA-Z_])*
INTEGER       0|("+"|"-")?[1-9][0-9]*
KEYWORD       "break"|"main"|"continue"|"else"|"float"|"for"|"if"|"int"|"return"|"void"|"while"|"do"|"double"|"extern"|"FILE"|"char"|"const"|"fopen"
OPERATOR      "+"|"-"|"*"|"/"|"="|"=="|"<="|">="|"."
DELIMITERS    "("|")"|"{"|"}"|"["|"]"|";"|","
ERROR         .

%%
\n                  { lines++; }
"//"                { BEGIN COMMENT; }
"/*"                { BEGIN C_COMMENT; }
<COMMENT>.          ;
<COMMENT>\n         { BEGIN 0; lines++; }
<C_COMMENT>.        ;
<C_COMMENT>\n       { lines++; }
<C_COMMENT><<EOF>>  { printf("%d: invalid comment.\n", lines); }
<C_COMMENT>"*/"     { BEGIN 0; }
<ERROR_OCCUR>" "    { BEGIN 0; }
<ERROR_OCCUR>\n     { BEGIN 0; lines++; }
<ERROR_OCCUR>.      ;

[ ]                 ;
{STRING}            {
  g_tokens[token_len].type = 0;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
}
{MACRO}             {
  g_tokens[token_len].type = 1;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
  lines++;
}
{KEYWORD}           {
  g_tokens[token_len].type = 3;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
}
{ID}                {
  g_tokens[token_len].type = 2;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
}
{DELIMITERS}        {
  g_tokens[token_len].type = 4;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
}
{OPERATOR}          {
  g_tokens[token_len].type = 5;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
}
{INTEGER}           {
  g_tokens[token_len].type = 6;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
}
{ERROR}             {
  g_tokens[token_len].type = 7;
  g_tokens[token_len].lineno = lines;
  strcpy(g_tokens[token_len].data, yytext);
  token_len++;
  BEGIN ERROR_OCCUR;
}
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

  for (int i = 0; i < token_len; ++i) {
    if (g_tokens[i].type == 7) {
      printf("%d: Error occured! Unknown token: %s\n", g_tokens[i].lineno, g_tokens[i].data);
      continue;
    }
    printf("%d: %s\t%s", g_tokens[i].lineno, Type[g_tokens[i].type],
           g_tokens[i].data);
    if (g_tokens[i].type != 1) printf("\n");

  }

  return 0;
}