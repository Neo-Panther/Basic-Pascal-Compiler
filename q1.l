%option noyywrap
%{
#include <stdio.h>
int line_no=1;
%}

letter [a-zA-Z]
underscore _
digit [0-9]
space [\t]*
RELATIONAL_OPERATOR  "=="|"="|"<>"|"<="|">="
ARITHMETIC_OPERATOR  "*"|"\\"|"*"|"%"|"+"
BOOLEAN_OPERATOR     "and"|"or"
PUNCTUATOR ","|";"|":"
%%

{space}  {}
\n { line_no++; ; }
"program"    { printf("%d     KEYWORD      program\n",line_no); }
"integer"    { printf("%d     KEYWORD      integer\n",line_no); }
"real"       { printf("%d     KEYWORD      real\n",line_no); }
"boolean"    { printf("%d     KEYWORD      boolean\n",line_no); }
"char"       { printf("%d     KEYWORD      char\n",line_no); }
"var"        { printf("%d     KEYWORD      var\n",line_no); }
"to"         { printf("%d     KEYWORD      to\n",line_no); }
"downto"     { printf("%d     KEYWORD      downto\n",line_no); }
"if"         { printf("%d     KEYWORD      if\n",line_no); }
"else"       { printf("%d     KEYWORD      else\n",line_no); }
"while"      { printf("%d     KEYWORD      while\n",line_no); }
"for"        { printf("%d     KEYWORD      for\n",line_no); }
"do"         { printf("%d     KEYWORD      do\n",line_no); }
"array"      { printf("%d     KEYWORD      array\n",line_no); }
"not"        { printf("%d     KEYWORD      not\n",line_no); }
"begin"      { printf("%d     KEYWORD      begin\n",line_no); }
"end"        { printf("%d     KEYWORD      end\n",line_no); }
"read"       { printf("%d     KEYWORD      read\n",line_no); }
"write"      { printf("%d     KEYWORD      write\n",line_no); }
{BOOLEAN_OPERATOR}            { printf("%d      BOOLEAN_OPERATOR   %s \n",line_no,yytext); }
{letter}({letter}|{digit}|{underscore})*  { printf("%d   IDENTIFIER, %s  \n",line_no, yytext); }
{digit}+   { printf("%d   NUMBER  %s\n",line_no, yytext); }
{PUNCTUATOR}       { printf("%d      PUNCTUATOR      %s \n",line_no,yytext); }
{RELATIONAL_OPERATOR}         { printf("%d      RELATIONAL_OPERATOR   %s \n",line_no,yytext); }
{ARITHMETIC_OPERATOR}         { printf("%d     ARITHMETIC_OPERATOR   %s \n",line_no,yytext); }
.          {}
%%

int main() {
 //   printf("line number       lexeme        tokenType\n");
    yyin = fopen("data.txt", "r");
    yylex();
 printf("Total lines: %d\n", line_no); // Print the total lines
    return 0;
}
