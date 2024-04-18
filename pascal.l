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
space [\t ]*
type ("boolean"|"integer"|"real"|"char")
operator "+"|"*"|"-"|"/"|"%"|"and"|"or"|">"|">="|"<>"|">"|"<"|"<="|"="
%%

{space}  {}
\n { line_no++;  }
\"[^\"]*\"  {return STRING;}
":="        {return ASSIGNMENT_OPERATOR;}
then        {return THEN;}
NOT         {return NOT;}
{operator}  {printf("\nbop %s",yytext);return BIN_OPERATOR;}
{type}      {printf("%s\n",yytext);return TYPE;}
"program"    { printf("%s\n",yytext);return PROGRAM; }
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
"readln"    {return READ;}
"of"         {return OF;}   
"write"      { return WRITE; }
"writeln"   { return WRITELN; }
";"          {printf("%s",yytext);return yytext[0];}
","          { printf("\n %s",yytext); return yytext[0];}
":"          { printf("\n %s",yytext);return yytext[0];}
"."          {return yytext[0];}
"["            {return yytext[0];}
"]"            {return yytext[0];}
"("              {return yytext[0];}
")"              {return yytext[0];}

{letter}({letter}|{digit}|{underscore})*  { printf("\n identifier \n%s",yytext);return ID; }
{digit}+   {return NUMBER; }

.          {}
%%


