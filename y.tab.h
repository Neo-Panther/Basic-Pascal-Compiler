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
     COMMENT_HANDLER = 266,
     PROGRAM = 267,
     VAR = 268,
     TO = 269,
     IF = 270,
     ELSE = 271,
     WHILE = 272,
     FOR = 273,
     DO = 274,
     DOWNTO = 275,
     BGN = 276,
     END = 277,
     READ = 278,
     WRITE = 279,
     TYPE = 280,
     OF = 281,
     WRITELN = 282
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
#define COMMENT_HANDLER 266
#define PROGRAM 267
#define VAR 268
#define TO 269
#define IF 270
#define ELSE 271
#define WHILE 272
#define FOR 273
#define DO 274
#define DOWNTO 275
#define BGN 276
#define END 277
#define READ 278
#define WRITE 279
#define TYPE 280
#define OF 281
#define WRITELN 282




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

