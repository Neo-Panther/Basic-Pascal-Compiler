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
    printf("SYNTAX CORRECT");
      exit(0);
};

var_section: var_list var_section | var_list|
{ 
};

var_list: list ':' stype ';'
{
   
}; 
stype: TYPE | ARRAY '['  NUMBER '.' '.' NUMBER ']' OF TYPE ;
list: ID ',' list | ID 
{};

block_begin:BGN block_sup END; 
block_sup: stmnt block_sup|stmnt
{
   
};

stmnt: WRITE '(' write ')' ';' | READ '(' aopvalue ')' ';' | aopvalue ASSIGNMENT_OPERATOR operation ';' | FOR fr ';' |WHILE while';'| IF if | WRITELN '(' write ')' ';'|
{
   
}

write: opvalue ',' write | STRING ',' write | aopvalue |STRING;

fr: ID ASSIGNMENT_OPERATOR operation TO operation DO block_begin | ID ASSIGNMENT_OPERATOR operation DOWNTO operation DO block_begin
{
  
};
while : condition DO block_begin 
{
    
};

opvalue: ID|NUMBER|ID '[' operation ']';  // operation values which return a value
aopvalue: ID|ID '[' operation ']';  // operation values which can be assigned stuff

operation: operation BIN_OPERATOR operation |'(' operation ')' | opvalue | NOT operation
{

};

if:condition THEN block_begin else;

condition: operation
{
}


else: ELSE block_begin ';'|';';
%%

void yyerror()
{
printf("Invalid SYNATX:\n"); exit(0);
}


int main() {
   
    yyparse();
    return 0;
}