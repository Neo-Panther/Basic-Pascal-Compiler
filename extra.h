#ifndef EXTRA_H_INCLUDED
# define EXTRA_H_INCLUDED
// Store array data
typedef struct arraydata{
  int first;
  int last;
  char type;
  void* array;
} adata;

// A Binary Tree as the Syntax|Parse Tree
typedef struct BinaryTreeNode{
  struct BinaryTreeNode* left;
  struct BinaryTreeNode* right;
  char* token;
} binarynode;

struct syntax_name{
  char name[300];
  struct BinaryTreeNode* nd;
  char type;
  adata atype;
  float value;
  char if_body[10];
  char else_body[10];
};
#endif