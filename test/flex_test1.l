%{
#include <stdio.h>
%}

%option noyywrap

%%
"int"                  { printf("KEYWORD: int\n"); }
[0-9]+                 { printf("INTEGER: %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER: %s\n", yytext); }
"="                    { printf("ASSIGN\n"); }
";"                    { printf("SEMICOLON\n"); }
[ \t\n]+               ; // 忽略空白
%%

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file1 [file2 ...]\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {		// 遍历多个文件
        FILE *file = fopen(argv[i], "r");
        if (!file) {
            perror(argv[i]);
            continue;
        }

        printf("=== Processing file: %s ===\n", argv[i]);
        yyrestart(file);  // 关键：安全地设置输入并清除缓冲
        yylex();
        fclose(file);
        printf("=== End of %s ===\n\n", argv[i]);
    }

    return 0;
}