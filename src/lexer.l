%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
int line_number = 1;
%}

%option noyywrap
%option yylineno
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENT       [a-zA-Z][a-zA-Z0-9_]*
STRING      \"[^\"]*\"
TIME        {DIGIT}{DIGIT}:{DIGIT}{DIGIT}
WHITESPACE  [ \t\r]+

%%


"TASK"      { return TASK; }
"RUN"       { return RUN; }
"EVERY"     { return EVERY; }
"DAY"       { return DAY; }
"WEEK"      { return WEEK; }
"ON"        { return ON; }
"AT"        { return AT; }
"AFTER"     { return AFTER; }
"BEFORE"    { return BEFORE; }
"DEPENDS"   { return DEPENDS; }
"IF"        { return IF; }
"success"   { return SUCCESS; }
"failure"   { return FAILURE; }
"SUNDAY"    { return SUNDAY; }
"MONDAY"    { return MONDAY; }
"TUESDAY"   { return TUESDAY; }
"WEDNESDAY" { return WEDNESDAY; }
"THURSDAY"  { return THURSDAY; }
"FRIDAY"    { return FRIDAY; }
"SATURDAY"  { return SATURDAY; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
{TIME}      { yylval.str = strdup(yytext); return TIME_VAL; }
{STRING}    { yylval.str = strdup(yytext); return STRING_LITERAL; }
{IDENT}     { yylval.str = strdup(yytext); return IDENTIFIER; }
{WHITESPACE} { }
\n          { line_number++; }
"#"[^\n]*   { }
.           { fprintf(stderr, "[Lexer Error] Line %d: Unknown character '%s'\n", line_number, yytext); }
%%
