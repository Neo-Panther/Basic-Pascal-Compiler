/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     NUMBER = 259,
     BIN_OPERATOR = 260,
     STRING = 261,
     ARRAY = 262,
     THEN = 263,
     ASSIGNMENT_OPERATOR = 264,
     NOT = 265,
     PROGRAM = 266,
     VAR = 267,
     TO = 268,
     IF = 269,
     ELSE = 270,
     WHILE = 271,
     FOR = 272,
     DO = 273,
     DOWNTO = 274,
     BGN = 275,
     END = 276,
     READ = 277,
     WRITE = 278,
     TYPE = 279,
     OF = 280,
     WRITELN = 281
   };
#endif
/* Tokens.  */
#define ID 258
#define NUMBER 259
#define BIN_OPERATOR 260
#define STRING 261
#define ARRAY 262
#define THEN 263
#define ASSIGNMENT_OPERATOR 264
#define NOT 265
#define PROGRAM 266
#define VAR 267
#define TO 268
#define IF 269
#define ELSE 270
#define WHILE 271
#define FOR 272
#define DO 273
#define DOWNTO 274
#define BGN 275
#define END 276
#define READ 277
#define WRITE 278
#define TYPE 279
#define OF 280
#define WRITELN 281




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

