# Basic Pascal Compiler
This project aims to build a compiler for a language close to pascal, but with fewer features using lex and yacc.

## Compiling Any Task
Run the following in order (in folder ot the respective task):
```
> flex KUCH1BHI.l
> yacc -d KUCH1BHI.y
> gcc lex.yy.c y.tab.c
> ./a.out <filename>
```
Replace \<filename\> with file name of the input file.

> **TASK 3**: Syntax tree can be printed using `python tree.py` (code copied as it is from course cms)

## Important Notes
1. Following Semantic errors are identified: "Undeclared Variable", "Uninitialized Variable", "Multiple Declarations", "Type Mismatch" in task 3.
2. $ti are temporary variables in task 4.
3. `extra.h` is required to run any task (already present in the same folder).
4. extra files created during task 5 compilation can be safely ignored (and deleted after task terminates). They are pascal code compiled to c language.
