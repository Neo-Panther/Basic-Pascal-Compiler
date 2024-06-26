%option noyywrap
%option yylineno
%option caseless
%{
#include <stdio.h>
int line_no=1;
%}

letter [a-zA-Z]
underscore _
digit [0-9]
space [\t \r]*
type ("boolean"|"integer"|"real"|"char")
operator "+"|"*"|"-"|"/"|"%"
boolean_op  "and"|"or"|"NOT"
relational_op ">"|">="|"<>"|"<"|"<="|"="
char ['](.|\n)[']
%%

{space}  {}
\n { line_no++;  }
\"[^\"]*\"  {printf("%d                        \"\"                   STRING(text skipped) \n",line_no);}
"//".*"\n"     {
  printf("%d                        //                   COMMENT(text skipped) \n",line_no);line_no++;}
":="        {printf("%d                        %s                   ASSIGNMENT_OPERATOR \n",line_no,yytext);}
then        {printf("%d                        %s                   KEYWORD \n",line_no,yytext);}
{boolean_op}        {printf("%d                        %s                   BOOLEAN_OPERATOR \n",line_no,yytext);}
{operator}  {printf("%d                        %s                   ARITHMETIC_OPERATOR \n",line_no,yytext);}
{relational_op}   {printf("%d                        %s                   RELATIONAL_OPERATOR \n",line_no,yytext);}
{type}      {printf("%d                        %s                   DATA_TYPE \n",line_no,yytext);}
"program"   {printf("%d                        %s                   KEYWORD \n",line_no,yytext);}
"var"       {printf("%d                        %s                   KEYWORD \n",line_no,yytext);}
"to"        {printf("%d                        %s                   KEYWORD \n",line_no,yytext);}
"downto"    {printf("%d                        %s                   KEYWORD \n",line_no,yytext);}
"if"        {printf("%d                        %s                   KEYWORD \n",line_no,yytext);}
"else"      {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"while"     {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"for"       {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"do"        {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"array"     {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"begin"     {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"end"       {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"read"      {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"of"        {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }   
"write"     {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
"writeln"   {printf("%d                        %s                   KEYWORD \n",line_no,yytext); }
{letter}({letter}|{digit}|{underscore})*   {printf("%d                        %s                   IDENTIFIER \n",line_no,yytext); } 
{digit}+"."{digit}{1,7} {printf("%d                        %s                   REAL NUMBER \n",line_no,yytext); }
{digit}+   {printf("%d                        %s                   NUMBER \n",line_no,yytext); } 
{char} {printf("%d                        %s                   CHAR \n",line_no,yytext); }  
";"         {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext); }
","         {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext); }
":"         {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext); }
"."         {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext); }
"["            {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext);}
"]"            {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext);}
"("              {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext);}
")"              {printf("%d                        %s                   PUNCTUATOR \n",line_no,yytext);}
.                {printf("%d                        %s                 UNKNOWN SYMBOL\n",line_no,yytext);}
%%


int main()
{
  printf("Enter file name(max 1000 chars): ");
  char file[1000];
  fgets(file, 1000, stdin);
  file[strlen(file)-1]=0;
   {printf("LINE NUMBER                 LEXEME                     TOKEN TYPE \n"); }
   yyin=fopen(file,"r");
   yylex();
}