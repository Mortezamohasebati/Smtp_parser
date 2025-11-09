%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%define parse.error verbose

%token TOKEN_HELO TOKEN_MAIL_FROM TOKEN_RCPT_TO TOKEN_DATA
%token TOKEN_SUBJECT TOKEN_END_OF_DATA TOKEN_QUIT TOKEN_TEXT

%%

smtp:
      TOKEN_HELO TOKEN_MAIL_FROM TOKEN_RCPT_TO TOKEN_DATA message TOKEN_QUIT
        { printf("SMTP syntax is correct.\n"); }

    | TOKEN_HELO error
        { yyerror("Syntax Error: MAIL FROM expected after HELO."); YYABORT; }

    | TOKEN_HELO TOKEN_MAIL_FROM error
        { yyerror("Syntax Error: RCPT TO expected after MAIL FROM."); YYABORT; }

    | TOKEN_HELO TOKEN_MAIL_FROM TOKEN_RCPT_TO error
        { yyerror("Syntax Error: DATA expected after RCPT TO."); YYABORT; }

    | TOKEN_HELO TOKEN_MAIL_FROM TOKEN_RCPT_TO TOKEN_DATA error
        { yyerror("Syntax Error: Subject and body expected after DATA."); YYABORT; }

    | error
        { yyerror("Syntax Error: Invalid SMTP command structure."); YYABORT; }
    ;

message:
      TOKEN_SUBJECT body TOKEN_END_OF_DATA
    | TOKEN_SUBJECT error
        { yyerror("Syntax Error: Body expected after Subject."); YYABORT; }
    ;

body:
      TOKEN_TEXT
    | body TOKEN_TEXT
    ;

%%

int main() {
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}
