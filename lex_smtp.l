%{
#include "parser.tab.h"
%}

%%

^HELO[ \t]+.*              { return TOKEN_HELO; }
^MAIL[ \t]+FROM:.*         { return TOKEN_MAIL_FROM; }
^RCPT[ \t]+TO:.*           { return TOKEN_RCPT_TO; }
^DATA[ \t]*$               { return TOKEN_DATA; }
^Subject:.*                { return TOKEN_SUBJECT; }
^\.[ \t]*$                 { return TOKEN_END_OF_DATA; }
^QUIT[ \t]*$               { return TOKEN_QUIT; }
^[^\n]+                    { return TOKEN_TEXT; }
.|\n                       { /* نادیده گرفتن بقیه */ }

%%
int yywrap() { return 1; }
