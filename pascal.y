%{
  #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int yylex();
   void yyerror();
    
%}


%start Start 
%token ID NUMBER BIN_OPERATOR STRING
%token ARRAY THEN ASSIGNMENT_OPERATOR NOT COMMENT_HANDLER
%token PROGRAM VAR TO IF ELSE WHILE FOR DO DOWNTO
%token BGN END READ WRITE TYPE OF WRITELN
%%

Start :  PROGRAM ID ';' VAR var_section block_begin '.'
{
    printf("coreect");
      exit(0);
};

var_section: var_list var_section | var_list|
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

stmnt: WRITE '(' write ')' ';' | READ '(' aopvalue ')' ';' | aopvalue ASSIGNMENT_OPERATOR operation ';' | FOR fr ';' |WHILE while';'| IF if | WRITELN '(' write ')' ';'|
{
    printf("stmt correct");
}

write: opvalue ',' write | STRING ',' write | aopvalue |STRING;

fr: ID ASSIGNMENT_OPERATOR operation TO operation DO block_begin | ID ASSIGNMENT_OPERATOR operation DOWNTO operation DO block_begin
{
    printf("correct for loop");
};
while : condition DO block_begin 
{
    printf("correct while loop");
};

opvalue: ID|NUMBER|ID '[' operation ']';  // operation values which return a value
aopvalue: ID|ID '[' operation ']';  // operation values which can be assigned stuff

operation: operation BIN_OPERATOR operation |'(' operation ')' | opvalue | NOT operation
{
    printf("operation successful");
};

if:condition THEN block_begin else;

condition: operation
{
    printf("True if this operation returns boolean type");
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