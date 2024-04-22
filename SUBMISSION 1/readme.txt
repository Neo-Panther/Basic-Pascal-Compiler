# Basic Pascal Compiler
This project aims to build a compiler for a language close to pascal, but with fewer features using lex and yacc.

## Compiling Task 1
Run the following in order (in folder TASK 1):
```
> flex KUCH1BHI.l
> gcc lex.yy.c -ll
> ./a.out
```
Enter the input file name at the prompt.

## Compiling Task 2
Run the following in order (in folder TASK 2):
```
> flex KUCH1BHI.l
> yacc -d KUCH1BHI.y
> gcc lex.yy.c y.tab.c -ll
> ./a.out
```
Enter the input file name at the prompt.

## Important Notes
1. Compiling the pascal file leads to shift/reduce conflicts, which are due to the simplified implementation of the operation (arithmetic and relational expression) rules.

2. Compiling all files into a.out leads to a warning for the usage of `gets`. This can be safely ignored until the size of the input file name is less than 1000 characters (as also mentioned in the prompt).

3. Unknown characters in the input file are ignored (treated as a blank space).

## Group Members

S.No.  ID             Name
1.     2021A7PS0136H  Anmol Agarwal
2.     2021A7PS0162H  Aryan Gupta
3.     2021A7PS1407H  Subal Tankwal
4.     2021A7PS2689H  Mihir Kulkarni
5.     2021A7PS2808H  Shrey Paunwala