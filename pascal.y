%{
  #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int yylex();
   void yyerror();
    
%}

%start var_section_begin
%token ID NUMBER KEYWORD ARITHMETIC_OPERATOR OPERATOR RELATIONAL_OPERATOR BOOLEAN_OPERATOR
%token PUNCTUATOR ARRAY
%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO IF ELSE WHILE FOR DO 
%token BGN END READ WRITE SEMICOLON TYPE COMMA COLON statements OF
%%

Start :  PROGRAM ID ';'  var_section BGN statements END '.'
{
    printf("coreect");
};
var_section_begin: VAR var_section |VAR
{
    printf("var_sevtion_begin correct");
};
var_section: var_list var_section | var_list
{
    printf("var_section correct    ");
};

var_list: list ':' stype ';'
{
    printf("var_list correct \n");
};
stype: TYPE | ARRAY '['  NUMBER '.' '.' NUMBER ']' OF TYPE ;
list: ID ',' list | ID 
{printf("correct list");};
%%

void yyerror()
{
printf("Invalid statement:\n"); exit(0);
}


int main() {
    printf("he\n");
    yyparse();
    return 0;
}
