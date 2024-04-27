%{
  #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>
  #include<ctype.h>
  #include<stdbool.h>
  #include<math.h>
  #include "extra.h"
  #include "treegen.h"
  // 127 variable name max length
  int yylex();
  void yyerror(const char *s);
  extern int line_no;
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
  trienode* list_vars[20];
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
      printf("Line %d: Semantic Error: Multiple declarations of the variable: %s\n", line_no, name);
      return;
    }
    cnode->isValid = 1;
    cnode->isInitialized = 0;
    list_vars[list_vars_i++] = cnode;
  }
  // NOTE: DONT call this for arrays. for arrays, get value and update manually
  void updateSymbolTable(char* name, int ivalue, float fvalue){
    if(symboltable[calcValue(name[0])] == (trienode*)0){
      printf("Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
      return;
    }
    trienode* cnode = symboltable[calcValue(name[0])];
    for(int i = 1; i < strlen(name); i += 1){
      if(cnode->children[calcValue(name[i])] == (trienode*)0){
        printf("Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
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
      printf("Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
      return NULL;
    }
    trienode* cnode = symboltable[calcValue(name[0])];
    for(int i = 1; i < strlen(name); i += 1){
      if(cnode->children[calcValue(name[i])] == (trienode*)0){
        printf("Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
        return NULL;
      }
      cnode = cnode->children[calcValue(name[i])];
    }
    if(!cnode->isValid){
      printf("Line %d: Semantic Error: Undeclared Varable: %s\n", line_no, name);
      return NULL;
    }
    return cnode;
  }
  void printType(char type){
    switch(type){
      case 'i': printf("integer"); break;
      case 'b': printf("boolean"); break;
      case 'c': printf("char"); break;
      case 'r': printf("real"); break;
      case 'a': printf("array"); break;
      default: printf("-%c-", type);
    }
  }
  void printSymbolTable(int idx, trienode* cnodes[27], char current_name[127]){
    if(idx == 0) printf("Variable    Type    Value\n");
    else if(idx == 127) return;
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
            printf("::Printing ARRAY %s of Type ", current_name); printType(cnodes[i]->value.avalue.type);
            printf("::\n");
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
    printf("got real %d+%f/%f     %d\n", num, (double)den,pow(10.0, denlen), denlen);
    return (float)num+((float)den/(float)pow(10.0, denlen));
  }
%}

%union {
  struct syntax_name{
    char name[127];
    struct BinaryTreeNode* nd;
    char type;
    adata atype;
    float value;
  } sname;
}

%start Start
%token <sname> STRING ASSIGNMENT_OPERATOR THEN NOT AND OR GE LE NE TBOOL TINT TREAL TCHAR PROGRAM VAR TO DOWNTO IF ELSE WHILE FOR DO ARRAY BGN END READ WRITE OF ID LREAL LINTEGER LCHAR MUL DIV MOD LT GT MINUS PLUS EQ
%type <sname> Start var_section definition ntype block_begin block_sup stmnt write fr while opvalue aopvalue operation bin_operator unary_operator if else write2 stype var_list

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
  printf("valid input\n");
  return 0;
};

var_section: definition var_section {
  $$.nd = mknode($1.nd, $2.nd, "var_section");
}
|
{
  $$.nd = NULL;
};
// TODO: give type in backward direction
definition: var_list ':' stype ';'{
  $$.nd = mknode($1.nd, $3.nd, "definition");
  for(int i = 0; i < list_vars_i; i++){
    list_vars[i]->type = $3.type;
    if($3.type == 'a'){
      list_vars[i]->value.avalue.first = $3.atype.first;
      list_vars[i]->value.avalue.last = $3.atype.last;
      list_vars[i]->value.avalue.type = $3.atype.type;
      if($3.atype.type != 'r')
        list_vars[i]->value.avalue.array = calloc($3.atype.last-$3.atype.first+1, sizeof(int));
      else
        list_vars[i]->value.avalue.array = calloc($3.atype.last-$3.atype.first+1, sizeof(float));
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
  char tmp[127] = "-";
  strcat(tmp, $4.name);
  $$.nd = mknode(mknode(mknode(NULL, NULL, tmp), mknode(NULL, NULL, $7.name), "range"), mknode(NULL, NULL, $10.name), "array");
}
| ARRAY '[' MINUS LINTEGER '.' '.' MINUS LINTEGER ']' OF ntype{
  $$.atype.first = -atoi($4.name);
  $$.atype.last = -atoi($8.name);
  $$.atype.type = $11.type;
  $$.type = 'a';
  char tmp[127] = "-";
  strcat(tmp, $4.name);
  char tmp1[127] = "-";
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
  $$.nd = mknode(mknode(NULL, NULL, $1.name), $3.nd, "var_list");
}
| ID {
  addToSymbolTable($1.name);
  $$.nd = mknode(NULL, NULL, $1.name);
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
}
| aopvalue ASSIGNMENT_OPERATOR operation ';'{
  char tp = $1.type;
  if(tp == 'a') tp = $1.atype.type;
  if(tp != $3.type){
    printf("Line %d: Semantic Error: Type Mismatch: %s", line_no, $1.name);
    printf(" of type: "); printType(tp); printf(" is being assigned value of type: "); printType($3.type); printf("\n");
  }
  if($1.type!='a'){
    updateSymbolTable($1.name, $3.value, $3.value);
  } else {
    trienode* entry = getSymbolTableNode($1.name);
    if (entry != NULL){
      if($1.atype.first > entry->value.avalue.last){
        printf("Line %d: Semantic Error: Array out-of-bounds access: %s", line_no, $1.name);
      } else {
      if($3.atype.type == 'r')
        ((float*)entry->value.avalue.array)[$1.atype.first - entry->value.avalue.first] = (float)$3.value;
      else
        ((int*)entry->value.avalue.array)[$1.atype.first - entry->value.avalue.first] = (int)$3.value;
      }
    }
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
}
;
write2: aopvalue ',' write2{
  $$.nd = mknode($1.nd, $3.nd, "var_list");
}
| aopvalue{
  $$.nd = $1.nd;
}
;

fr: ID ASSIGNMENT_OPERATOR operation TO operation DO block_begin{
  if($1.type != $3.type){
    printf("Line %d: Semantic Error: Type Mismatch: %s", line_no, $1.name);
    printf(" of type: "); printType($1.type); printf(" is being assigned value of type: "); printType($3.type); printf("\n");
  }
  if($3.type != $5.type){
    printf("Line %d: Semantic Error: Type Mismatch - For: first expression", line_no);
    printf(" of type: "); printType($1.type); printf(" second expression of type: "); printType($3.type); printf("\n");
  }
  updateSymbolTable($1.name, $3.value, $3.value);
  $$.nd = mknode(mknode(mknode(mknode(NULL, NULL, $1.name), $3.nd, ":="), $5.nd,"range_upto"), $7.nd, "for");
}
| ID ASSIGNMENT_OPERATOR operation DOWNTO operation DO block_begin{
  if($1.type != $3.type){
    printf("Line %d: Semantic Error: Type Mismatch: %s", line_no, $1.name);
    printf(" of type: "); printType($1.type); printf(" is being assigned value of type: "); printType($3.type); printf("\n");
  }
  if($3.type != $5.type){
    printf("Line %d: Semantic Error: Type Mismatch - For: first expression", line_no);
    printf(" of type: "); printType($1.type); printf(" second expression of type: "); printType($3.type); printf("\n");
  }
  updateSymbolTable($1.name, $3.value, $3.value);
  $$.nd = mknode(mknode(mknode(mknode(NULL, NULL, $1.name), $3.nd, ":="), $5.nd,"range_downto"), $7.nd, "for");
};
while: operation DO block_begin {
  if($1.type != 'b'){
    printf("Line %d: Semantic Error: Type Mismatch - While: condition is not a boolean expression\n", line_no);
  }
  $$.nd = mknode($1.nd, $3.nd, "while");
};

opvalue: ID{
  trienode* entry = getSymbolTableNode($1.name);
  $$.value = 0;
  $$.type = 'i';
  if(entry != NULL){
    $$.type = entry->type;
    if(entry->type == 'a'){
      printf("Line %d: Semantic Error: Type Mismatch - Arrays cannot be used without [] operator\n", line_no);
    } else {
      if(!entry->isInitialized){
        printf("Line %d: Semantic Error: Uninitialized Variable: %s\n", line_no, $1.name);
      } else {
        $$.value = (entry->type == 'a') ? entry->value.rvalue : entry->value.nrvalue;
      }
    }
  }
  $$.nd = mknode(NULL, NULL, $1.name);
}
| LINTEGER{
  $$.type = 'i';
  $$.value = atoi($1.name);
  $$.nd = mknode(NULL, NULL, $1.name);
}
| LCHAR{
  $$.type = 'c';
  $$.value = $1.name[1];
  $$.nd = mknode(NULL, NULL, $1.name);
}
| LREAL{
  $$.type = 'r';
  $$.value = getRealValue($1.name);
  $$.nd = mknode(NULL, NULL, $1.name);
}
| ID '[' operation ']' {
  trienode* entry = getSymbolTableNode($1.name);
  if($3.type != 'i'){
    printf("Line %d: Semantic Error: Type Mismatch - Only integer can be used for array access\n", line_no);
  }
  $$.value = 0;
  $$.type = 'i';
  if(entry != NULL){
    if(entry->type != 'a')
      printf("Line %d: Semantic Error: Type Mismatch - Cannot apply [] operator to variables which are not arrays\n", line_no);
    else {
      $$.type = entry->value.avalue.type;
      if($3.value > entry->value.avalue.last){
        printf("Line %d: Semantic Error: Array out-of-bounds access: %s", line_no, $1.name);
      } else {
        if($$.type == 'r')
          $$.value = ((float*)entry->value.avalue.array)[(int)$3.value - entry->value.avalue.first];
        else
          $$.value = ((int*)entry->value.avalue.array)[(int)$3.value - entry->value.avalue.first];
      }
    }
  }
  $$.nd = mknode(mknode(NULL, NULL, $1.name), $3.nd, "array_access");
};
// operation values which return a value
aopvalue: ID {
  strcpy($$.name, $1.name);
  trienode* entry = getSymbolTableNode($1.name);
  if(entry != NULL){
    $$.type = entry->type;
    if(entry->type == 'a'){
      printf("Line %d: Semantic Error: Type Mismatch - Arrays can only be used with [] operator\n", line_no);
    }
  }
  $$.nd = mknode(NULL, NULL, $1.name);
}
| ID '[' operation ']' {
  strcpy($$.name, $1.name);
  trienode* entry = getSymbolTableNode($1.name);
  $$.type = 'a';
  $$.atype.type = 'i';
  if($3.type == 'r'){
    printf("Line %d: Semantic Error: Type Mismatch - Real values cannot be used for array access\n", line_no);
  }
  if(entry != NULL){
    if(entry->type != 'a'){
      printf("Line %d: Semantic Error: Type Mismatch - Only arrays can be used with the [] operator\n", line_no);
    } else {
      $$.atype = entry->value.avalue;
    }
  }
  $$.atype.first = (int)$3.value;
  $$.nd = mknode(mknode(NULL, NULL, $1.name), $3.nd, "array_access");
};  ;  // operation values which can be assigned stuff

operation: operation bin_operator operation{
  switch($2.type){
    case 0:
      $$.value = $1.value + $3.value;
      if($1.type != $3.type){
        printf("Line %d: Semantic Error: Type Mismatch: ", line_no);
        printf(" of type: "); printType($1.type); printf(" is being added to value of type: "); printType($3.type); printf("\n");
      }
      break;
    case 1:
      $$.value = $1.value - $3.value;
      if($1.type != $3.type){
        printf("Line %d: Semantic Error: Type Mismatch: ", line_no);
        printf(" of type: "); printType($1.type); printf(" is being subtracted from a value of type: "); printType($3.type); printf("\n");
      }
      break;
    case 2:
      $$.value = $1.value * $3.value;
      if($1.type != $3.type){
        printf("Line %d: Semantic Error: Type Mismatch: ", line_no);
        printf(" of type: "); printType($1.type); printf(" is being multiplied to value of type: "); printType($3.type); printf("\n");
      }
      break;
    case 3:
      $$.value = (float)$1.value / (float)$3.value;
      $$.type = 'r';
      break;
    case 4:
      if($1.type != 'i' || $3.type != 'i'){
        printf("Line %d: Semantic Error: Only integer variables can be used with %%\n", line_no);
      }
      $$.value = (int)$1.value % (int)$3.value;
      $$.type = 'i';
      break;
    case 5:
      if(($3.value == 0 || $3.value == 1) && ($1.value == 0|| $1.value == 1)){
        printf("Line %d: Semantic Error: AND both value must be boolean (1 and 0)", line_no);
      }
      $$.value = $1.value && $3.value;
      $$.type = 'b';
      break;
    case 6:
      if(($3.value == 0 || $3.value == 1) && ($1.value == 0|| $1.value == 1)){
        printf("Line %d: Semantic Error: OR both value must be boolean (1 and 0)\n", line_no);
      }
      $$.value = $1.value || $3.value;
      $$.type = 'b';
      break;
    case 7:
      $$.value = $1.value != $3.value;
      $$.type = 'b';
      break;
    case 8:
      if(($3.value == 0 || $3.value == 1) && ($1.value == 0|| $1.value == 1)){
        printf("Line %d: Semantic Error: >= Not applicable on boolean operands\n", line_no);
      }
      $$.value = ($1.value >= $3.value);
      $$.type = 'b';
      break;
    case 9:
      if(($3.value == 0 || $3.value == 1) && ($1.value == 0|| $1.value == 1)){
        printf("Line %d: Semantic Error: <= Not applicable on boolean operands\n", line_no);
      }
      $$.value = ($1.value <= $3.value);
      $$.type = 'b';
      break;
    case 10:
      $$.value = ($1.value == $3.value);
      $$.type = 'b';
      break;
    case 11:
      if(($3.value == 0 || $3.value == 1) && ($1.value == 0|| $1.value == 1)){
        printf("Line %d: Semantic Error: < Not applicable on boolean operands\n", line_no);
      }
      $$.value = ($1.value < $3.value);
      $$.type = 'b';
      break;
    case 12:
      if(($3.value == 0 || $3.value == 1) && ($1.value == 0|| $1.value == 1)){
        printf("Line %d: Semantic Error: > Not applicable on boolean operands\n", line_no);
      }
      $$.value = ($1.value > $3.value);
      $$.type = 'b';
      break;
    default:
      printf("FFF");
  }
  $$.nd = mknode($1.nd, $3.nd, $2.name);
}
| '(' operation ')'{
  $$.type = $2.type;
  $$.value = $2.value;
  $$.nd = $2.nd;
}
| opvalue {
  $$.type = $1.type;
  $$.value = $1.value;
  $$.nd = $1.nd;
}
| unary_operator operation{
  switch($1.name[0]){
    case '-':
      $$.value = -$2.value;
      $$.type = $2.type;
      break;
    case '+':
      $$.value = -$2.value;
      $$.type = $2.type;
      break;
    default:
      if($1.value == 0 || $1.value == 1){
        printf("Line %d: Semantic Error: NOT - value must be boolean (0 or 1)", line_no);
      }
      $$.value = ($2.value != 0) ? 1: 0;
      $$.type = 'b';
      break;
  }
  $$.nd = mknode(NULL, $2.nd, $1.name);
};
bin_operator: PLUS{
  strcpy($$.name, $1.name);
  $$.type = 0;
}
| MINUS{
  strcpy($$.name, $1.name);
  $$.type = 1;
}
| MUL{
  strcpy($$.name, $1.name);
  $$.type = 2;
}
| DIV{
  strcpy($$.name, $1.name);
  $$.type = 3;
}
| MOD{
  strcpy($$.name, $1.name);
  $$.type = 4;
}
| AND{
  strcpy($$.name, $1.name);
  $$.type = 5;
}
| OR{
  strcpy($$.name, $1.name);
  $$.type = 6;
}
| NE{
  strcpy($$.name, $1.name);
  $$.type = 7;
}
| GE{
  strcpy($$.name, $1.name);
  $$.type = 8;
}
| LE{
  strcpy($$.name, $1.name);
  $$.type = 9;
}
| EQ{
  strcpy($$.name, $1.name);
  $$.type = 10;
}
| LT{
  strcpy($$.name, $1.name);
  $$.type = 11;
}
| GT{
  strcpy($$.name, $1.name);
  $$.type = 12;
}
;
unary_operator: NOT
| MINUS %prec MUL
| PLUS %prec MUL
;

if: operation THEN block_begin else{
  if($1.type != 'b'){
    printf("Line %d: Semantic Error: Type Mismatch - If: condition is not a boolean expression\n", line_no);
  }
  $$.nd = mknode($1.nd, mknode($3.nd, $4.nd, "then"), "if");
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
  printf("syntax error: %s: line no.: %d\n", s, line_no);
  exit(1);
}

int main() {
  memset(symboltable, 0, 27);
  list_vars_i = 0;
  yyparse();
  /* printSyntaxTree(syntaxroot); */
  ex(syntaxroot);
  printf("\n");
  char f[127];
  memset(f, 0, sizeof(char));
  printSymbolTable(0, symboltable, f);
  printf("------------------------------\n");
  freeSymbolTable(symboltable);
  return 0;
}