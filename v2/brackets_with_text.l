%{
#include "y.tab.h"
int comment_depth = 0;  // コメントの深さを追跡
%}

%%

"("    { return LPAREN; }
")"    { return RPAREN; }
"["    { return LBRACKET; }
"]"    { return RBRACKET; }
"{"    { return LBRACE; }
"}"    { return RBRACE; }
"/*"   { comment_depth++; return LCOMMENT; }
"*/"   { 
            if (comment_depth == 0) {
                printf("無効なコメント終了: %s\n", yytext);
                return TOKEN;
            }
            comment_depth--;
            return RCOMMENT;
        }
[^()\[\]{} \t\n/]+ { return TOKEN; }  // 括弧、空白類、スラッシュ以外の文字
"/"     { return TOKEN; }  // スラッシュ単体
[ \t\n] { return IGNORE; }
.       { printf("無効な文字: %s\n", yytext); return TOKEN; }

%%

int yywrap() {
    return 1;
}
