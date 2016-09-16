%{
  #include <iostream>
  #include "ast.h"
  #include "parser.h"

  void lexical_error(const char*);
  void yyerror(const char*);
%}

%option noyywrap

integer [0-9]+
identifier [a-zA-Z][a-zA-Z_0-9]*

%%

[ \t]         { }

{integer}     { yylval.val_int = std::atoi(yytext); return V_INT; }
{identifier}  { yylval.val_str = strdup(yytext); return T_IDENTIFIER; }

"int"[ \t]    { return D_INT; }

"+"           { return T_PLUS; }
"-"           { return T_MINUS; }
"*"           { return T_TIMES; }
"/"           { return T_DIVIDE; }
"("           { return T_POPEN; }
")"           { return T_PCLOSE; }
"="           { return T_ATTRIB; }
","           { return T_COMMA; }
\n            { return T_NEWLINE; }

.            { lexical_error(yytext); }

%%

void lexical_error(const char *s){
  std::cerr << "[Line " << yylineno << "] lexical error: unknown symbol "
    << s << std::endl;
}

void yyerror(const char *s){
  std::cerr << "[Line " << yylineno << "] syntax error" << std::endl;
}
