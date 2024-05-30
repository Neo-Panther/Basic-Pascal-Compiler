# Basic Pascal Compiler
This project aims to build a compiler for a language close to pascal, but with fewer features using lex and yacc.

## Compiling Task 1
Run the following in order (in folder TASK 1):
```
> flex KUCH1BHI.l
> gcc lex.yy.c
> ./a.out
```
Enter the input file name at the prompt.

## Compiling Task 2
Run the following in order (in folder TASK 2):
```
> flex KUCH1BHI.l
> yacc -d KUCH1BHI.y
> gcc lex.yy.c y.tab.c
> ./a.out
```
Enter the input file name at the prompt.
