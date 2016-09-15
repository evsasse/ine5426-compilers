%{
  #include <string>
  #include "parser.tab.h"

  void yyerror(const char*);
%}

%option noyywrap

number [0-9]+\.?[0-9]*

%%

[ \t]       { }
{number}    { yylval.val_double = std::atof(yytext); return T_DOUBLE; }
"+"         { return T_PLUS; }
"-"         { return T_MINUS; }
"*"         { return T_TIMES; }
"/"         { return T_DIVIDE; }
\n          { return T_NEWLINE; }
"exit"      { return T_EXIT; }
.           { yyerror(yytext); }

%%

void yyerror(const char* s){
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::fprintf(stderr, s);
}
