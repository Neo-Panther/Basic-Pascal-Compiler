# Basic Pascal Compiler
This project aims to build a compiler for a language close to pascal, but with fewer features using lex and yacc.

## Compiling Task 1
Run the following in order:
```
> flex q1.l
> gcc lex.yy.c -ll
> ./a.out
```
Enter the input file name at the prompt.

## Compiling Task 2
Run the following in order:
```
> flex pascal.l
> yacc -d pascal.y
> gcc lex.yy.c y.tab.c -ll
> ./a.out
```
Enter the input file name at the prompt.