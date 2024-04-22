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

## Important Notes (Assumptions)
1. Unknown characters in the input file are treated as a blank space.

## Group Members

S.No.  ID             Name
1.     2021A7PS0136H  Anmol Agarwal
2.     2021A7PS0162H  Aryan Gupta
3.     2021A7PS1407H  Subal Tankwal
4.     2021A7PS2689H  Mihir Kulkarni
5.     2021A7PS2808H  Shrey Paunwala