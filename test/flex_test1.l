%{
#include <stdio.h>
%}

%option noyywrap

%%
[0-9]+                 { printf("INTEGER: %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER: %s\n", yytext); }
"="                    { printf("ASSIGN\n"); }
";"                    { printf("SEMICOLON\n"); }
[ \t\n]+               ; // 忽略空白
%%

#include <stdio.h>
extern YY_BUFFER_STATE yy_scan_string(const char *str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

int main() {
    const char *text = "123 abc 456";
    YY_BUFFER_STATE buffer = yy_scan_string(text);
    yylex();
    yy_delete_buffer(buffer);
    return 0;
}
