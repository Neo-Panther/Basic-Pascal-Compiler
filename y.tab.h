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
     B_OPERATOR = 264,
     PUNCTUATOR = 265,
     ARRAY = 266,
     THEN = 267,
     ASSIGNMENT_OPERATOR = 268,
     NOT = 269,
     UOP = 270,
     PROGRAM = 271,
     INTEGER = 272,
     REAL = 273,
     BOOLEAN = 274,
     CHAR = 275,
     VAR = 276,
     TO = 277,
     IF = 278,
     ELSE = 279,
     WHILE = 280,
     FOR = 281,
     DO = 282,
     Q = 283,
     BGN = 284,
     END = 285,
     READ = 286,
     WRITE = 287,
     SEMICOLON = 288,
     TYPE = 289,
     COMMA = 290,
     COLON = 291,
     OF = 292,
     FORIF = 293,
     ANY = 294
   };
#endif
/* Tokens.  */
#define ID 258
#define NUMBER 259
#define KEYWORD 260
#define ARITHMETIC_OPERATOR 261
#define OPERATOR 262
#define RELATIONAL_OPERATOR 263
#define B_OPERATOR 264
#define PUNCTUATOR 265
#define ARRAY 266
#define THEN 267
#define ASSIGNMENT_OPERATOR 268
#define NOT 269
#define UOP 270
#define PROGRAM 271
#define INTEGER 272
#define REAL 273
#define BOOLEAN 274
#define CHAR 275
#define VAR 276
#define TO 277
#define IF 278
#define ELSE 279
#define WHILE 280
#define FOR 281
#define DO 282
#define Q 283
#define BGN 284
#define END 285
#define READ 286
#define WRITE 287
#define SEMICOLON 288
#define TYPE 289
#define COMMA 290
#define COLON 291
#define OF 292
#define FORIF 293
#define ANY 294




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

