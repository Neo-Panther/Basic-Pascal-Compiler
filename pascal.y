%{
  #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int yylex();
   void yyerror();
    
%}


%start Start 
%token ID NUMBER KEYWORD OPERATOR RELATIONAL_OPERATOR B_OPERATOR
%token PUNCTUATOR ARRAY THEN ASSIGNMENT_OPERATOR NOT UOP
%token PROGRAM INTEGER REAL BOOLEAN CHAR VAR TO IF ELSE WHILE FOR DO Q
%token BGN END READ WRITE SEMICOLON TYPE COMMA COLON  OF FORIF ANY
%%

Start :  PROGRAM ID ';' VAR var_section block_begin '.'
{
    printf("coreect");
      exit(0);
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

block_begin:BGN block_sup END; 
block_sup: stmnt block_sup|stmnt
{
    printf("correct block\n");
};

stmnt:  WRITE '(' write ')' ';' | READ '(' n2 ')' ';' | n2 ASSIGNMENT_OPERATOR operation ';' |FOR fr ';' |WHILE while';'| IF if
{
    printf("stmt correct");
}
write: n2 ',' write | ANY ',' write | n2 |ANY;


fr: ID ASSIGNMENT_OPERATOR operation TO operation DO block_begin 
{
    printf("correct for loop");
};
while : condition DO block_begin 
{
    printf("correct while loop");
};

n1: ID|NUMBER|ID '[' operation ']';
n2: ID|ID '[' operation ']';

operation: operation OPERATOR operation|'(' operation OPERATOR operation ')'|n1|'(' n1 ')'
{
    printf("operation successful");
};

if:condition THEN block_begin else;

condition:
{

}; 


else: ELSE block_begin ';'|';';
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
