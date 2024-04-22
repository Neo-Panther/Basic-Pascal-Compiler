%option noyywrap
%option yylineno
%option caseless
%{
#include <stdio.h>
#include "y.tab.h"
int line_no=1;
%}

letter [a-zA-Z]
underscore _
digit [0-9]
char ['].[']
space [\t \r]*
type ("boolean"|"integer"|"real"|"char")
operator "*"|"/"|"%"|"and"|"or"|">="|"<>"|">"|"<"|"<="|"="
%%

{space}  {}
\n { line_no++;  }
\"[^\"]*\"  {return STRING;}
"//".*"\n"     {line_no++;}
":="        {return ASSIGNMENT_OPERATOR;}
then        {return THEN;}
NOT         {return NOT;}
{operator}  {return BIN_OPERATOR;}
{type}      {return TYPE;}
"program"    { return PROGRAM; }
"var"        { return VAR; }
"to"         { return TO; }
"downto"        {return DOWNTO;}
"if"         { return IF; }
"else"       { return ELSE; }
"while"      {return WHILE; }
"for"        {return FOR; }
"do"         { return DO; }
"array"      { return ARRAY; }
"begin"      { return BGN; }
"end"        { return END; }
"read"       { return READ; }
"of"         {return OF;}   
"write"      { return WRITE; }
"writeln"   { return WRITELN; }
{letter}({letter}|{digit}|{underscore})*  { return ID; }
{digit}+"."{digit}{1,7} {return  NUMBER;}
{digit}+   {return NUMBER; }
{char}      {return NUMBER;}
"-"          {return yytext[0];}
"+"          {return yytext[0];}
";"          {return yytext[0];}
","          {  return yytext[0];}
":"          { return yytext[0];}
"."          {return yytext[0];}
"["            {return yytext[0];}
"]"            {return yytext[0];}
"("              {return yytext[0];}
")"              {return yytext[0];}

.         {return yytext[0];}
%%