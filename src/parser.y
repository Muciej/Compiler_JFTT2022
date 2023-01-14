/*
 * Parser kompilatora "głupiego", JFTT2022
 *
 * Autor: Maciek Józefkowicz
*/

%{

#include <iostream>

#include "logic.cpp"
using namespace std;

extern int yylineno;
int yylex( void );
void yyset_in( FILE* in_str);
void yyerror(char const* s);

%}

%union {
  long long l_val;
  char const* str_val;
}

%token IDENTIFIER
%token NUM
%token KW_PROGRAM
%token KW_PROCEDURE
%token KW_IS
%token KW_BEGIN
%token KW_VAR
%token KW_END
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_ENDIF
%token KW_WHILE
%token KW_DO
%token KW_ENDWHILE
%token KW_REPEAT
%token KW_READ
%token KW_WRITE
%token KW_UNTIL
%token KW_EOF
%token EQ	// =
%token LTEQ	// <=
%token GTEQ	// >=
%token LT	// <
%token GT	// >
%token UNEQ	// !=
%token SET 	// :=
%token SEMI 	// ;
%token PLUS	// +
%token MINUS	// -
%token TIMES	// *
%token MOD	// %
%token DIV	// /
%token COMMA	// ,
%token L_PAR	// (
%token R_PAR	// )

%%

program_all:
procedures main KW_EOF
;

procedures:
%empty
| procedures KW_PROCEDURE proc_head KW_IS KW_VAR declarations KW_BEGIN commands KW_END
| procedures KW_PROCEDURE proc_head KW_IS KW_BEGIN commands KW_END
;

main:
KW_PROGRAM KW_IS KW_VAR declarations KW_BEGIN commands KW_END
| KW_PROGRAM KW_IS KW_BEGIN commands KW_END
;

commands:
commands command
| command
;

command:
IDENTIFIER SET expression SEMI
| KW_IF condition KW_THEN commands KW_ELSE commands KW_ENDIF
| KW_IF condition KW_THEN commands KW_ENDIF
| KW_WHILE condition KW_DO commands KW_ENDWHILE
| KW_REPEAT commands KW_UNTIL condition SEMI
| proc_head SEMI
| KW_READ IDENTIFIER SEMI
| KW_WRITE value SEMI
;

proc_head:
IDENTIFIER L_PAR declarations R_PAR
;

declarations:
declarations COMMA IDENTIFIER
| IDENTIFIER
;

expression:
value
| value PLUS value
| value MINUS value
| value TIMES value
| value DIV value
| value MOD value
;

condition:
value EQ value
| value UNEQ value
| value GT value
| value LT value
| value GTEQ value
| value LTEQ value
;

value:
NUM
| IDENTIFIER
;

%%

void yyerror(char const *s){
  cerr<< s << "in line " << yylineno << endl;
}

void run(FILE* data, FILE* out){
  cout << "Kompilacja" << endl;
  yyset_in(data);
  yyparse();
}