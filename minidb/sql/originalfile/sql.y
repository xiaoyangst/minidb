%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char** columns;
    int column_count;
    char* table;
    char* where;
} SelectQuery;

extern int yylex(void);
void yyerror(const char *s);
char* strdup_safe(const char* src);
void print_select_query(SelectQuery* q);
void add_column(const char* col);

SelectQuery* last_select_query = NULL;
char** column_list = NULL;
int column_count = 0;

%}

%union {
    int ival;
    char* sval;
    SelectQuery* selectQuery;
}

%token <sval> IDENTIFIER STRING
%token <ival> INTEGER

%token SELECT FROM WHERE GROUP BY ORDER ASC DESC
%token INSERT INTO VALUES UPDATE SET DELETE
%token CREATE TABLE INDEX
%token JOIN LEFT RIGHT FULL OUTER INNER ON
%token AND OR NOT NULLVAL
%token EQ NEQ GT GEQ LT LEQ
%token COMMA LPAREN RPAREN STAR DOT
%token SEMICOLON

%type <sval> expression opt_where
%type <selectQuery> select_stmt

%%

query:
    select_stmt SEMICOLON {
        last_select_query = $1;
    }
    | insert_stmt SEMICOLON
    | update_stmt SEMICOLON
    | delete_stmt SEMICOLON
    | create_stmt SEMICOLON
    ;

select_stmt:
    SELECT select_list FROM IDENTIFIER opt_where opt_group opt_order {
        SelectQuery* q = malloc(sizeof(SelectQuery));
        q->columns = column_list;
        q->column_count = column_count;
        q->table = strdup_safe($4);
        q->where = $5 ? strdup_safe($5) : NULL;
        column_list = NULL;
        column_count = 0;
        $$ = q;
    }
    ;

select_list:
    STAR {
        add_column("*");
    }
    | select_list COMMA expression {
        add_column($3);
    }
    | expression {
        column_list = NULL;
        column_count = 0;
        add_column($1);
    }
    ;

opt_where:
    /* empty */ { $$ = NULL; }
    | WHERE expression { $$ = $2; }
    ;

opt_group:
    /* empty */
    | GROUP BY expression_list
    ;

opt_order:
    /* empty */
    | ORDER BY expression ASC
    | ORDER BY expression DESC
    ;

expression_list:
    expression
    | expression_list COMMA expression
    ;

expression:
    IDENTIFIER { $$ = strdup_safe($1); }
    | INTEGER {
        char buf[32];
        snprintf(buf, sizeof(buf), "%d", $1);
        $$ = strdup_safe(buf);
    }
    | STRING { $$ = strdup_safe($1); }
    | expression EQ expression {
        int len = strlen($1) + strlen($3) + 4;
        $$ = malloc(len);
        snprintf($$, len, "%s = %s", $1, $3);
    }
    | expression NEQ expression {
        int len = strlen($1) + strlen($3) + 5;
        $$ = malloc(len);
        snprintf($$, len, "%s != %s", $1, $3);
    }
    | expression GT expression {
        int len = strlen($1) + strlen($3) + 4;
        $$ = malloc(len);
        snprintf($$, len, "%s > %s", $1, $3);
    }
    | expression GEQ expression {
        int len = strlen($1) + strlen($3) + 5;
        $$ = malloc(len);
        snprintf($$, len, "%s >= %s", $1, $3);
    }
    | expression LT expression {
        int len = strlen($1) + strlen($3) + 4;
        $$ = malloc(len);
        snprintf($$, len, "%s < %s", $1, $3);
    }
    | expression LEQ expression {
        int len = strlen($1) + strlen($3) + 5;
        $$ = malloc(len);
        snprintf($$, len, "%s <= %s", $1, $3);
    }
    | expression AND expression {
        int len = strlen($1) + strlen($3) + 6;
        $$ = malloc(len);
        snprintf($$, len, "%s AND %s", $1, $3);
    }
    | expression OR expression {
        int len = strlen($1) + strlen($3) + 5;
        $$ = malloc(len);
        snprintf($$, len, "%s OR %s", $1, $3);
    }
    ;

table_ref:
    IDENTIFIER
    | table_ref COMMA IDENTIFIER
    | table_ref join_type IDENTIFIER ON expression
    ;

join_type:
    JOIN
    | INNER JOIN
    | LEFT JOIN
    | RIGHT JOIN
    | FULL JOIN
    ;

insert_stmt:
    INSERT INTO IDENTIFIER LPAREN column_list RPAREN VALUES value_list
    ;

column_list:
    IDENTIFIER
    | column_list COMMA IDENTIFIER
    ;

value_list:
    LPAREN expression_list RPAREN
    | value_list COMMA LPAREN expression_list RPAREN
    ;

update_stmt:
    UPDATE IDENTIFIER SET assignment_list opt_where
    ;

assignment_list:
    IDENTIFIER EQ expression
    | assignment_list COMMA IDENTIFIER EQ expression
    ;

delete_stmt:
    DELETE FROM IDENTIFIER opt_where
    ;

create_stmt:
    CREATE TABLE IDENTIFIER LPAREN column_defs RPAREN
    ;

column_defs:
    IDENTIFIER IDENTIFIER
    | column_defs COMMA IDENTIFIER IDENTIFIER
    ;

%%

int main(void) {
    printf("Enter SQL statement:\n");
    if (yyparse() == 0) {
        printf("SQL statement parsed successfully!\n");
        print_select_query(last_select_query);
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
