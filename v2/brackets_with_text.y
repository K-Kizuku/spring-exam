%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
extern int comment_depth;  // Lexファイルからコメントの深さを取得
extern char *yytext;       // Lexからのトークン文字列

#define MAX_OUTPUT_LENGTH 1024
char parse_result[MAX_OUTPUT_LENGTH];
int parse_result_pos = 0;

void add_to_parse_result(const char *str);
void reset_parse_result(void);

char error_message[MAX_OUTPUT_LENGTH];

%}

%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE LCOMMENT RCOMMENT TOKEN IGNORE

%%

input:
    /* empty */
    | input expr
    ;

expr:
    matching_parens
    | matching_parens expr
    | non_parens
    | non_parens expr
    ;

matching_parens:
    LPAREN expr RPAREN { add_to_parse_result("()"); }
    | LBRACKET expr RBRACKET { add_to_parse_result("[]"); }
    | LBRACE expr RBRACE { add_to_parse_result("{}"); }
    | LCOMMENT expr RCOMMENT { add_to_parse_result("/* */"); }
    ;

non_parens:
    /* empty */
    | non_parens token
    ;

token:
    TOKEN { add_to_parse_result(yytext); }
    | IGNORE
    ;

%%

void yyerror(const char *s) {
    snprintf(error_message, sizeof(error_message), "エラー: %s near '%s'", s, yytext);
}

void add_to_parse_result(const char *str) {
    int len = strlen(str);
    if (parse_result_pos + len < MAX_OUTPUT_LENGTH) {
        strcpy(&parse_result[parse_result_pos], str);
        parse_result_pos += len;
    }
}

void reset_parse_result(void) {
    parse_result[0] = '\0';  // 解析結果の初期化
    parse_result_pos = 0;
    error_message[0] = '\0';
}

int main(void) {
    reset_parse_result();

    if (yyparse() == 0 && comment_depth == 0) {  // コメントの深さも確認
        printf("括弧の整合性が取れています\n");
        printf("構文解析結果: %s\n", parse_result);
    } else {
        printf("括弧の整合性が取れていません\n");
        if (comment_depth > 0) {
            printf("原因: コメントが終了していません。\n");
        } else if (strlen(error_message) > 0) {
            printf("%s\n", error_message);
        }
    }
    return 0;
}
