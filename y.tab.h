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
     KEYWORD = 260,
     ARITHMETIC_OPERATOR = 261,
     OPERATOR = 262,
     RELATIONAL_OPERATOR = 263,
     BOOLEAN_OPERATOR = 264,
     PUNCTUATOR = 265,
     ARRAY = 266,
     PROGRAM = 267,
     INTEGER = 268,
     REAL = 269,
     BOOLEAN = 270,
     CHAR = 271,
     VAR = 272,
     TO = 273,
     IF = 274,
     ELSE = 275,
     WHILE = 276,
     FOR = 277,
     DO = 278,
     BGN = 279,
     END = 280,
     READ = 281,
     WRITE = 282,
     SEMICOLON = 283,
     TYPE = 284,
     COMMA = 285,
     COLON = 286,
     statements = 287,
     OF = 288
   };
#endif
/* Tokens.  */
#define ID 258
#define NUMBER 259
#define KEYWORD 260
#define ARITHMETIC_OPERATOR 261
#define OPERATOR 262
#define RELATIONAL_OPERATOR 263
#define BOOLEAN_OPERATOR 264
#define PUNCTUATOR 265
#define ARRAY 266
#define PROGRAM 267
#define INTEGER 268
#define REAL 269
#define BOOLEAN 270
#define CHAR 271
#define VAR 272
#define TO 273
#define IF 274
#define ELSE 275
#define WHILE 276
#define FOR 277
#define DO 278
#define BGN 279
#define END 280
#define READ 281
#define WRITE 282
#define SEMICOLON 283
#define TYPE 284
#define COMMA 285
#define COLON 286
#define statements 287
#define OF 288




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

