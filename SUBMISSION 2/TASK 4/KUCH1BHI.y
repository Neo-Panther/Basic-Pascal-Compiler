%{
  #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>
  #include<ctype.h>
  #include<stdbool.h>
  #include<math.h>
  #include "extra.h"
  // 300 variable name max length
  extern FILE* yyin;
  int yylex();
  void yyerror(const char *s);
  extern int line_no;
  int label_i = 0;
  int temp_var = 0;
  char tac[100][300];  // 100 max lines of TAC
  int tac_i = 0;
  char s_errors[100][300];  // 100 max lines of semantic errors
  int s_errors_i = 0;
  typedef union Value{
    int nrvalue;
    float rvalue;
    adata avalue;
  } uvalue;
  typedef struct TrieNode{
    struct TrieNode* children[27];
    bool isValid;
    bool isInitialized;
    char type;
    uvalue value;
  } trienode;
  trienode* symboltable[27];
  trienode* list_vars[20];  // 20 maximum variables in one definition
  char names[20][300];
  int list_vars_i;
  int calcValue(char chr){
    if (islower(chr)) return chr - 'a';
    else if (isupper(chr)) return chr - 'A';
    else return 26;
  }
  binarynode* syntaxroot;
  // Type, avalue has to be set separately
  void addToSymbolTable(char* name){
    bool newv = false;
    if(symboltable[calcValue(name[0])] == (trienode*)0){
      newv = true;
      symboltable[calcValue(name[0])] = (trienode*)calloc(1, sizeof(trienode));
    }
    trienode* cnode = symboltable[calcValue(name[0])];
    for(int i = 1; i < strlen(name); i += 1){
      if(cnode->children[calcValue(name[i])] == (trienode*)0){
        newv = true;
        cnode->children[calcValue(name[i])] = (trienode*)calloc(1, sizeof(trienode));
      }
      cnode = cnode->children[calcValue(name[i])];
    }
    if(!newv){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Multiple declarations of the variable: %s\n", line_no, name);
      return;
    }
    cnode->isValid = 1;
    cnode->isInitialized = 0;
    strcpy(names[list_vars_i], name);
    list_vars[list_vars_i++] = cnode;
  }
  // NOTE: DONT call this for arrays. for arrays, get value and update manually
  void updateSymbolTable(char* name, int ivalue, float fvalue){
    if(symboltable[calcValue(name[0])] == (trienode*)0){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
      return;
    }
    trienode* cnode = symboltable[calcValue(name[0])];
    for(int i = 1; i < strlen(name); i += 1){
      if(cnode->children[calcValue(name[i])] == (trienode*)0){
        sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
        return;
      }
      cnode = cnode->children[calcValue(name[i])];
    }
    cnode->isValid = 1;
    cnode->isInitialized = 1;
    if(cnode->type == 'r') cnode->value.rvalue = fvalue;
    else cnode->value.nrvalue = ivalue;
  }
  trienode* getSymbolTableNode(char* name){
    if(symboltable[calcValue(name[0])] == (trienode*)0){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
      return NULL;
    }
    trienode* cnode = symboltable[calcValue(name[0])];
    for(int i = 1; i < strlen(name); i += 1){
      if(cnode->children[calcValue(name[i])] == (trienode*)0){
        sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
        return NULL;
      }
      cnode = cnode->children[calcValue(name[i])];
    }
    if(!cnode->isValid){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
      return NULL;
    }
    return cnode;
  }
  char* getType(char type){
    switch(type){
      case 'i': return "integer";
      case 'b': return "boolean";
      case 'c': return "char";
      case 'r': return "real";
      case 'a': return "array";
      default: return "-unknown-";
    }
  }
  void printSymbolTable(int idx, trienode* cnodes[27], char current_name[300]){
    if(idx == 0) printf("Variable    Type    Value\n");
    else if(idx == 300) return;
    for(int i = 0; i < 27; i++){
      if(cnodes[i] != (trienode*)0){
        current_name[idx] = (char)i+'a';
        if(i == 26) current_name[idx] = '_';
        if(cnodes[i]->isValid){
          if(cnodes[i]->type == 'r')
            printf("%s          REAL          %f", current_name, cnodes[i]->value.rvalue);
          else if(cnodes[i]->type == 'p'){
            printf("%s       PROGRAM_ID       -", current_name);
          } else if(cnodes[i]->type == 'i'){
            printf("%s         INTEGER          %d", current_name, cnodes[i]->value.nrvalue);
          } else if(cnodes[i]->type == 'c'){
            printf("%s         CHAR          %c", current_name, cnodes[i]->value.nrvalue);
          } else if(cnodes[i]->type == 'b'){
            printf("%s         BOOLEAN          %d", current_name, cnodes[i]->value.nrvalue);
          } else{
            printf("::Printing ARRAY %s of Type %s::\n", current_name, getType(cnodes[i]->value.avalue.type));
            printf("Index                 Value\n");
            for(int j = cnodes[i]->value.avalue.first; j < cnodes[i]->value.avalue.last; j++){
              if(cnodes[i]->value.avalue.type == 'c'){
                printf("%d                      %c\n", j, ((int*)cnodes[i]->value.avalue.array)[j-cnodes[i]->value.avalue.first]);
              } else if(cnodes[i]->value.avalue.type == 'r'){
                printf("%d                      %f\n", j, ((float*)cnodes[i]->value.avalue.array)[j-cnodes[i]->value.avalue.first]);
              } else {
                printf("%d                      %d\n", j, ((int*)cnodes[i]->value.avalue.array)[j-cnodes[i]->value.avalue.first]);
              }
            }
            printf("--------------------------------------\n");
          }
          printf("\n");
        }
        printSymbolTable(idx+1, cnodes[i]->children, current_name);
        current_name[idx] = 0;
      }
    }
  }
  void freeSymbolTable(trienode* cnodes[27]){
    for(int i = 0; i < 27; i++){
      if(cnodes[i] != (trienode*)0){
        freeSymbolTable(cnodes[i]->children);
        if(cnodes[i]->type == 'a') free(cnodes[i]->value.avalue.array);
        free(cnodes[i]);
      }
    }
  }

  binarynode* mknode(binarynode* left, binarynode* right, char* token){
    binarynode* new_node = (binarynode*)calloc(1, sizeof(binarynode*));
    new_node->token = (char*)calloc(strlen(token+1), sizeof(char));
    strcpy(new_node->token, token);
    new_node->left = left;
    new_node->right = right;
    return new_node;
  }
  float getRealValue(char* name){
    int num = atoi(name);
    int numlen;
    if(num == 0) numlen = 0;
    else numlen = round(log(num)/log(10.0));
    int den = atoi(name+2+numlen);
    int denlen;
    if(num == 0) denlen = 0;
    else denlen = strlen(name)-2-numlen;
    return (float)num+((float)den/(float)pow(10.0, denlen));
  }
  void printSErrors(){
    printf("Number of Semantic Errors: %d\n", s_errors_i);
    for(int i = 0; i < s_errors_i; i++){
      printf("%s", s_errors[i]);
    }
  }
  void printTAC(){
    printf("%d TAC:\n", tac_i);
    for(int i = 0; i < tac_i; i++){
      printf("%s", tac[i]);
    }
  }

  void printSyntaxTree(FILE* f, binarynode* syntaxroot){
    if(syntaxroot == NULL) return;
    fprintf(f, "[%s", syntaxroot->token);
    printSyntaxTree(f, syntaxroot->left);
    printSyntaxTree(f, syntaxroot->right);
    fprintf(f, "]");
  }
%}

%union {
  struct syntax_name sname;
}

%start Start
%token <sname> STRING ASSIGNMENT_OPERATOR THEN NOT AND OR GE LE NE TBOOL TINT TREAL TCHAR PROGRAM VAR TO DOWNTO IF ELSE WHILE FOR DO ARRAY BGN END READ WRITE OF ID LREAL LINTEGER LCHAR MUL DIV MOD LT GT MINUS PLUS EQ
%type <sname> Start var_section definition ntype block_begin block_sup stmnt write fr while opvalue aopvalue operation if else write2 stype var_list

%left LE LT NE EQ GE GT
%left PLUS MINUS OR
%left MUL DIV MOD AND
%left NOT
%right ',' ':'
%%

Start: PROGRAM ID ';' VAR var_section block_begin '.'{
  adata t;
  addToSymbolTable($2.name);
  list_vars[0]->type = 'p';
  list_vars_i = 0;
  $4.nd = mknode($5.nd, $6.nd, "var");
  $$.nd = mknode(mknode(NULL, NULL, $2.name), $4.nd, "program");
  syntaxroot = $$.nd;
  return 0;
};

var_section: definition var_section {
  $$.nd = mknode($1.nd, $2.nd, "var_section");
}
|
{
  $$.nd = NULL;
};
definition: var_list ':' stype ';'{
  $$.nd = mknode($1.nd, $3.nd, "definition");
  for(int i = 0; i < list_vars_i; i++){
    list_vars[i]->type = $3.type;
    if($3.type == 'a'){
      sprintf(tac[tac_i++], "%s: %d..%d | %s\n", names[i], $3.atype.first, $3.atype.last, getType($3.atype.type));
      list_vars[i]->value.avalue.first = $3.atype.first;
      list_vars[i]->value.avalue.last = $3.atype.last;
      list_vars[i]->value.avalue.type = $3.atype.type;
      list_vars[i]->isInitialized = 1;
      if($3.atype.type != 'r')
        list_vars[i]->value.avalue.array = calloc($3.atype.last-$3.atype.first+1, sizeof(int));
      else
        list_vars[i]->value.avalue.array = calloc($3.atype.last-$3.atype.first+1, sizeof(float));
    } else {
      sprintf(tac[tac_i++], "%s : %s\n", names[i], getType($3.type));
    }
  }
  list_vars_i = 0;
};
stype: ntype {
  $$.type = $1.type;
  $$.nd = mknode(NULL, NULL, $1.name);
}
| ARRAY '[' LINTEGER '.' '.' LINTEGER ']' OF ntype {
  $$.atype.first = atoi($3.name);
  $$.atype.last = atoi($6.name);
  $$.atype.type = $9.type;
  $$.type = 'a';
  $$.nd = mknode(mknode(mknode(NULL, NULL, $3.name), mknode(NULL, NULL, $6.name), "range"), mknode(NULL, NULL, $9.name), "array");
}
| ARRAY '[' MINUS LINTEGER '.' '.' LINTEGER ']' OF ntype{
  $$.atype.first = -atoi($4.name);
  $$.atype.last = atoi($7.name);
  $$.atype.type = $10.type;
  $$.type = 'a';
  char tmp[300] = "-";
  strcat(tmp, $4.name);
  $$.nd = mknode(mknode(mknode(NULL, NULL, tmp), mknode(NULL, NULL, $7.name), "range"), mknode(NULL, NULL, $10.name), "array");
}
| ARRAY '[' MINUS LINTEGER '.' '.' MINUS LINTEGER ']' OF ntype{
  $$.atype.first = -atoi($4.name);
  $$.atype.last = -atoi($8.name);
  $$.atype.type = $11.type;
  $$.type = 'a';
  char tmp[300] = "-";
  strcat(tmp, $4.name);
  char tmp1[300] = "-";
  strcat(tmp1, $8.name);
  $$.nd = mknode(mknode(mknode(NULL, NULL, tmp), mknode(NULL, NULL, tmp1), "range"), mknode(NULL, NULL, $11.name), "array");
}
;
ntype: TBOOL{
  strcpy($$.name, $1.name);
  $$.type = 'b';
}
| TCHAR{
  strcpy($$.name, $1.name);
  $$.type = 'c';
}
| TINT{
  strcpy($$.name, $1.name);
  $$.type = 'i';
}
| TREAL{
  strcpy($$.name, $1.name);
  $$.type = 'r';
}
var_list: ID ',' var_list{
  addToSymbolTable($1.name);
  char tmp[300];
  sprintf(tmp, "var:{%.250s}", $1.name);
  $$.nd = mknode(mknode(NULL, NULL, tmp), $3.nd, "var_list");
}
| ID {
  addToSymbolTable($1.name);
  char tmp[300];
  sprintf(tmp, "var:{%.250s}", $1.name);
  $$.nd = mknode(NULL, NULL, tmp);
};

block_begin: BGN block_sup END {
  $$.nd = mknode(mknode(NULL, NULL, "begin"), $2.nd, "block");
};
block_sup: stmnt block_sup{
  $$.nd = mknode($1.nd, $2.nd, "block_stmts");
}
| {
  $$.nd = mknode(NULL, NULL, "end");
};

stmnt: WRITE '(' write ')' ';' {
  $$.nd = mknode(mknode(NULL, NULL, "write"), $3.nd, "stmt");
}
| READ '(' aopvalue ')' ';'{
  $$.nd = mknode(mknode(NULL, NULL, "read"), $3.nd, "stmt");
  if($3.type != 'a'){
    updateSymbolTable($3.name, 0, 0.0);
  }
  sprintf(tac[tac_i++], "READ %s\n", $3.name);
}
| aopvalue ASSIGNMENT_OPERATOR operation ';'{
  char tp = $1.type;
  if(tp == 'a') tp = $1.atype.type;
  if(tp != $3.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: %s  of type: %s is being assigned value of type: %s\n", line_no, $1.name, getType(tp), getType($3.type));
  }
  sprintf(tac[tac_i++], "%s := %s\n", $1.name, $3.name);
  if($1.type!='a'){
    updateSymbolTable($1.name, $3.value, $3.value);
  } else {
    trienode* entry = getSymbolTableNode($1.name);
  }
  $$.nd = mknode($1.nd, $3.nd, ":=");
}
| FOR fr ';'{
  $$.nd = $2.nd;
}
| WHILE while';'{
  $$.nd = $2.nd;
}
| IF if{
  $$.nd = $2.nd;
}
| block_begin ';'{
  $$.nd = $1.nd;
};

write: write2{
  $$.nd = $1.nd;
}
| STRING{
  $$.nd = mknode(NULL, NULL, $1.name);
  sprintf(tac[tac_i++], "WRITE %s\n", $1.name);
}
;
write2: aopvalue ',' write2{
  $$.nd = mknode($1.nd, $3.nd, "var_list");
  sprintf(tac[tac_i++], "WRITE %s\n", $1.name);
}
| aopvalue{
  $$.nd = $1.nd;
  sprintf(tac[tac_i++], "WRITE %s\n", $1.name);
}
;

fr: ID ASSIGNMENT_OPERATOR operation TO operation DO {
  if($1.type != $3.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: %s  of type: %s is being assigned value of type: %s\n", line_no, $1.name, getType($1.type), getType($3.type));
  }
  if($1.type != $5.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: %s  of type: %s is being assigned value of type: %s\n", line_no, $1.name, getType($1.type), getType($5.type));
  }
  sprintf(tac[tac_i++], "%s := %s\n", $1.name, $3.name);
  sprintf($<sname>$.if_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>$.if_body);
  sprintf($<sname>$.else_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nif (%s > %s) GOTO %s\n", $1.name, $5.name, $<sname>$.else_body);
  updateSymbolTable($1.name, $3.value, $3.value);
} block_begin {
  sprintf(tac[tac_i++], "%s := %s + 1\n", $1.name, $1.name);
  sprintf(tac[tac_i++], "GOTO %s\n", $<sname>7.if_body);
	sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>7.else_body);
  $$.nd = mknode(mknode(mknode(mknode(NULL, NULL, $1.name), $3.nd, ":="), $5.nd,"range_upto"), $8.nd, "for");
}
| ID ASSIGNMENT_OPERATOR operation DOWNTO operation DO {
  if($1.type != $3.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: %s  of type: %s is being assigned value of type: %s\n", line_no, $1.name, getType($1.type), getType($5.type));
  }
  if($1.type != $5.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: %s  of type: %s is being assigned value of type: %s\n", line_no, $1.name, getType($1.type), getType($3.type));
  }
  sprintf(tac[tac_i++], "%s := %s\n", $1.name, $3.name);
  sprintf($<sname>$.if_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>$.if_body);
  sprintf($<sname>$.else_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nif (%s < %s) GOTO %s\n", $1.name, $5.name, $<sname>$.else_body);
  updateSymbolTable($1.name, $3.value, $3.value);
} block_begin {
  sprintf(tac[tac_i++], "%s := %s - 1\n", $1.name, $1.name);
  sprintf(tac[tac_i++], "GOTO %s\n", $<sname>7.if_body);
	sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>7.else_body);
  $$.nd = mknode(mknode(mknode(mknode(NULL, NULL, $1.name), $3.nd, ":="), $5.nd,"range_downto"), $8.nd, "for");
};
while: {
  sprintf($<sname>$.if_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>$.if_body);
} operation DO {
  if($2.type != 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - While: condition is not a boolean expression\n", line_no);
  }
  sprintf($<sname>$.else_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nif NOT (%s) GOTO %s\n", $2.name, $<sname>$.else_body);
} block_begin {
  sprintf(tac[tac_i++], "GOTO %s\n", $<sname>1.if_body);
	sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>4.else_body);
  $$.nd = mknode($2.nd, $5.nd, "while");
};

opvalue: ID{
  strcpy($$.name, $1.name);
  trienode* entry = getSymbolTableNode($1.name);
  $$.value = 0;
  $$.type = 'u';
  if(entry != NULL){
    $$.type = entry->type;
    if(entry->type == 'a'){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - Arrays cannot be used without [] operator\n", line_no);
    } else {
      if(!entry->isInitialized){
        sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Uninitialized Variable: %s\n", line_no, $1.name);
      } else {
        $$.value = (entry->type == 'a') ? entry->value.rvalue : entry->value.nrvalue;
      }
    }
  }
  char tmp[300];
  sprintf(tmp, "var:{%.250s}", $1.name);
  $$.nd = mknode(NULL, NULL, tmp);
}
| LINTEGER{
  strcpy($$.name, $1.name);
  $$.type = 'i';
  $$.value = atoi($1.name);
  char tmp[300];
  sprintf(tmp, "integerc:{%.250s}", $1.name);
  $$.nd = mknode(NULL, NULL, tmp);
}
| LCHAR{
  strcpy($$.name, $1.name);
  $$.type = 'c';
  $$.value = $1.name[1];
  char tmp[300];
  sprintf(tmp, "charc:{%c}", $1.name[1]);
  $$.nd = mknode(NULL, NULL, tmp);
}
| LREAL{
  strcpy($$.name, $1.name);
  $$.type = 'r';
  $$.value = getRealValue($1.name);
  char tmp[300];
  sprintf(tmp, "realc:{%.250s}", $1.name);
  $$.nd = mknode(NULL, NULL, tmp);
}
| ID '[' operation ']' {
  sprintf($$.name, "%.130s[%.130s]", $1.name, $3.name);
  trienode* entry = getSymbolTableNode($1.name);
  if($3.type != 'i'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - Only integer can be used for array access\n", line_no);
  }
  $$.value = 0;
  $$.type = 'i';
  if(entry != NULL){
    if(entry->type != 'a')
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - Cannot apply [] operator to variables which are not arrays\n", line_no);
    else {
      $$.type = entry->value.avalue.type;
      if($3.value > entry->value.avalue.last){
        sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Array out-of-bounds access: %s", line_no, $1.name);
      } else {
        if($$.type == 'r')
          $$.value = ((float*)entry->value.avalue.array)[(int)$3.value - entry->value.avalue.first];
        else
          $$.value = ((int*)entry->value.avalue.array)[(int)$3.value - entry->value.avalue.first];
      }
    }
  }
  char tmp[300];
  sprintf(tmp, "array:{%.250s}", $1.name);
  $$.nd = mknode(mknode(NULL, NULL, tmp), $3.nd, "array_access");
};
// operation values which return a value
aopvalue: ID {
  strcpy($$.name, $1.name);
  trienode* entry = getSymbolTableNode($1.name);
  if(entry != NULL){
    $$.type = entry->type;
    if(entry->type == 'a'){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - Arrays can only be used with [] operator\n", line_no);
    }
  }
  char tmp[300];
  sprintf(tmp, "var:{%.250s}", $1.name);
  $$.nd = mknode(NULL, NULL, tmp);
}
| ID '[' operation ']' {
  trienode* entry = getSymbolTableNode($1.name);
  $$.type = 'a';
  $$.atype.type = 'i';
  sprintf($$.name, "%.130s[%.130s]", $1.name, $3.name);
  if($3.type != 'i'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - Only integer values can be used for array access\n", line_no);
  }
  if(entry != NULL){
    if(entry->type != 'a'){
      sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - Only arrays can be used with the [] operator\n", line_no);
    } else {
      $$.atype = entry->value.avalue;
    }
  }
  $$.atype.first = (int)$3.value;
  char tmp[300];
  sprintf(tmp, "arr:{%.250s}", $1.name);
  $$.nd = mknode(mknode(NULL, NULL, tmp), $3.nd, "array_access");
};  // operation values which can be assigned stuff

operation: operation PLUS operation{
  $$.value = $1.value + $3.value;
  if($1.type != $3.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: + between type: %s and type: %s\n", line_no, getType($1.type), getType($3.type));
  }
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation MINUS operation{
  $$.value = $1.value - $3.value;
  if($1.type != $3.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: - between type: %s and type: %s\n", line_no, getType($1.type), getType($3.type));
  }
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation MUL operation{
  $$.value = $1.value * $3.value;
  if($1.type != $3.type){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch: * between type: %s and type: %s\n", line_no, getType($1.type), getType($3.type));
  }
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation DIV operation{
  $$.type = 'r';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation MOD operation{
  if($1.type != 'i' || $3.type != 'i'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Only integer variables can be used with %%\n", line_no);
  }
  $$.value = (int)$1.value % (int)$3.value;
  $$.type = 'i';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation AND operation{
  if($3.type != 'b' || $1.type != 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: AND both value must be boolean", line_no);
  }
  $$.value = $1.value && $3.value;
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation OR operation{
  if($3.type != 'b' || $1.type != 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: OR both value must be boolean\n", line_no);
  }
  $$.value = $1.value || $3.value;
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation NE operation{
  $$.value = $1.value != $3.value;
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation GE operation{
  if($3.type == 'b' || $1.type == 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: >= Not applicable on boolean operands\n", line_no);
  }
  $$.value = ($1.value >= $3.value);
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation LE operation{
  if($3.type == 'b' || $1.type == 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: <= Not applicable on boolean operands\n", line_no);
  }
  $$.value = ($1.value <= $3.value);
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation EQ operation{
  $$.value = ($1.value == $3.value);
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation LT operation{
  if($3.type == 'b' || $1.type == 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: < Not applicable on boolean operands\n", line_no);
  }
  $$.value = ($1.value < $3.value);
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| operation GT operation{
  if($3.type == 'b' || $1.type == 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: > Not applicable on boolean operands\n", line_no);
  }
  $$.value = ($1.value > $3.value);
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s %s\n", $$.name, $1.name, $2.name, $3.name);
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| '(' operation ')'{
  // TODO: test with brackets and opvalues
  $$ = $2;
}
| opvalue {
  $$ = $1;
}
| '-' operation {
  if($2.type != 'i' && $2.type != 'r'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: '-' - value must be real or integer", line_no);
  }
  $$.value = -$2.value;
  $$.type = $2.type;
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := -%s\n", $$.name, $2.name);
  $$.nd = mknode(NULL, $2.nd, "-");
} %prec MUL
| '+' operation {
  $$.value = $2.value;
  $$.type = $2.type;
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s\n", $$.name, $2.name);
  $$.nd = mknode(NULL, $2.nd, "+");
} %prec MUL
| NOT operation {
  if($2.type != 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: NOT - value must be boolean", line_no);
  }
  $$.value = ($2.value != 0) ? 1: 0;
  $$.type = 'b';
  sprintf($$.name, "$t%d", temp_var++);
  sprintf(tac[tac_i++], "%s := %s %s\n", $$.name, $1.name, $2.name);
  $$.nd = mknode(NULL, $2.nd, $1.name);
};

if: operation THEN {
  if($1.type != 'b'){
    sprintf(s_errors[s_errors_i++], "Line %d: Semantic Error: Type Mismatch - If: condition is not a boolean expression\n", line_no);
  }
  sprintf($<sname>$.else_body, "L%d", label_i++);
  sprintf($<sname>$.if_body, "L%d", label_i++);
  sprintf(tac[tac_i++], "\nif NOT (%s) GOTO %s\n", $1.name, $<sname>$.else_body);
} block_begin {
  sprintf(tac[tac_i++], "GOTO %s\n", $<sname>3.if_body);
  sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>3.else_body);
} else {
  sprintf(tac[tac_i++], "\nLABEL %s:\n", $<sname>3.if_body);
  $$.nd = mknode($1.nd, mknode($4.nd, $6.nd, "then"), "if");
};

else: ELSE block_begin ';'{
  $$.nd = mknode(NULL, $2.nd, "else");
}
| ';' {
  $$.nd = NULL;
}
;
%%

void yyerror(const char* s){
  printf("%s: line no.: %d\n", s, line_no);
  exit(1);
}

int main(int argc, char** argv) {
  if(argc < 2){
    printf("Usage: %s <filename>\n", argv[0]);
    return 1;
  }
  yyin = fopen(argv[1], "r");
  memset(symboltable, 0, 27);
  list_vars_i = 0;
  yyparse();
  fclose(yyin);
  freeSymbolTable(symboltable);
  
  // Print TAC
  printTAC();
  return 0;
}