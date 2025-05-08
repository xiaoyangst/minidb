%{
#include "sql.tab.h"
#include <string.h>
%}

/* 不自动换行 */
%option noyywrap
/* 忽略大小写 */
%option case-insensitive

%%

"SELECT"        return SELECT;
"FROM"          return FROM;
"WHERE"         return WHERE;
"GROUP"         return GROUP;
"BY"            return BY;
"ORDER"         return ORDER;
"ASC"           return ASC;
"DESC"          return DESC;
"INSERT"        return INSERT;
"INTO"          return INTO;
"VALUES"        return VALUES;
"UPDATE"        return UPDATE;
"SET"           return SET;
"DELETE"        return DELETE;
"CREATE"        return CREATE;
"TABLE"         return TABLE;
"INDEX"         return INDEX;
"JOIN"          return JOIN;
"LEFT"          return LEFT;
"RIGHT"         return RIGHT;
"FULL"          return FULL;
"OUTER"         return OUTER;
"INNER"         return INNER;
"ON"            return ON;
"AND"           return AND;
"OR"            return OR;
"NOT"           return NOT;
"NULL"          return NULLVAL;

"="             return EQ;
"!="            return NEQ;
">="            return GEQ;
"<="            return LEQ;
">"             return GT;
"<"             return LT;

","             return COMMA;
"("             return LPAREN;
")"             return RPAREN;
"*"             return STAR;
"."             return DOT;
";"             return SEMICOLON;  // 返回分号


[0-9]+          { yylval.ival = atoi(yytext); return INTEGER; }     // 整数
\'[^\']*\'      { yylval.sval = strdup(yytext); return STRING; }    // 字符串
\"[^\"]*\"      { yylval.sval = strdup(yytext); return STRING; }    // 字符串
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.sval = strdup(yytext); return IDENTIFIER; }   // 标识符

[ \t\r\n]+      ; // 忽略空格和换行

.               { printf("Invalid character: %s\n", yytext); return '?'; }  // 其他字符

"/*"([^*]|\*+[^*/])*\*+"/"   ;      // 忽略多行注释
"//".*\n                     ;      // 忽略单行注释


%%
