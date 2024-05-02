%option yylineno
%option caseless
%{
#include <stdio.h>
#include <string.h>
#include "extra.h"
#include "y.tab.h"
int line_no=1;
%}

letter [a-zA-Z]
underscore _
digit [0-9]
char ['].[']
space [\t \r]*
%%

{space}  {;}
\n { line_no++;  }
\"[^\"]*\"  {strcpy(yylval.sname.name, yytext); return STRING;}
"//".*"\n"     {line_no++;}
":="        {strcpy(yylval.sname.name, yytext); return ASSIGNMENT_OPERATOR;}
then        {strcpy(yylval.sname.name, yytext); return THEN;}
NOT         {strcpy(yylval.sname.name, yytext); return NOT;}
"*"         {strcpy(yylval.sname.name, yytext); return MUL;}
"/"         {strcpy(yylval.sname.name, yytext); return DIV;}
"%"         {strcpy(yylval.sname.name, yytext); return MOD;}
"and"       {strcpy(yylval.sname.name, yytext); return AND;}
"or"        {strcpy(yylval.sname.name, yytext); return OR;}
">="        {strcpy(yylval.sname.name, yytext); return GE;}
"<>"        {strcpy(yylval.sname.name, yytext); return NE;}
">"         {strcpy(yylval.sname.name, yytext); return GT;}
"<"         {strcpy(yylval.sname.name, yytext); return LT;}
"<="        {strcpy(yylval.sname.name, yytext); return LE;}
"="         {strcpy(yylval.sname.name, yytext); return EQ;}
"boolean"   {strcpy(yylval.sname.name, yytext); return TBOOL;}
"integer"   {strcpy(yylval.sname.name, yytext); return TINT;}
"real"      {strcpy(yylval.sname.name, yytext); return TREAL;}
"char"      {strcpy(yylval.sname.name, yytext); return TCHAR;}
"program"    {strcpy(yylval.sname.name, yytext); return PROGRAM; }
"var"        {strcpy(yylval.sname.name, yytext); return VAR; }
"to"         {strcpy(yylval.sname.name, yytext); return TO; }
"downto"        {strcpy(yylval.sname.name, yytext); return DOWNTO;}
"if"         {strcpy(yylval.sname.name, yytext); return IF; }
"else"       {strcpy(yylval.sname.name, yytext); return ELSE; }
"while"      {strcpy(yylval.sname.name, yytext); return WHILE; }
"for"        {strcpy(yylval.sname.name, yytext); return FOR; }
"do"         {strcpy(yylval.sname.name, yytext); return DO; }
"array"      {strcpy(yylval.sname.name, yytext); return ARRAY; }
"begin"      {strcpy(yylval.sname.name, yytext); return BGN; }
"end"        {strcpy(yylval.sname.name, yytext); return END; }
"read"       {strcpy(yylval.sname.name, yytext); return READ; }
"write"      {strcpy(yylval.sname.name, yytext); return WRITE; }
"of"         {strcpy(yylval.sname.name, yytext); return OF;}   
{letter}({letter}|{digit}|{underscore})*  {strcpy(yylval.sname.name, yytext); return ID; }
{digit}+"."{digit}{1,7} {strcpy(yylval.sname.name, yytext); return LREAL;}
{digit}+   {strcpy(yylval.sname.name, yytext); return LINTEGER; }
{char}      {strcpy(yylval.sname.name, yytext); return LCHAR;}
"-"          {strcpy(yylval.sname.name, yytext); return MINUS;}
"+"          {strcpy(yylval.sname.name, yytext); return PLUS;}
";"          {return yytext[0];}
","          {return yytext[0];}
":"          {return yytext[0];}
"."          {return yytext[0];}
"["            {return yytext[0];}
"]"            {return yytext[0];}
"("              {return yytext[0];}
")"              {return yytext[0];}

.         {return yytext[0];}
%%
int yywrap(){
  return 1;
}