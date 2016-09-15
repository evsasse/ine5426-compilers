%{
  #include <string>
  #include "parser.tab.h"

  void yyerror(const char*);
%}

%option noyywrap

digits [0-9]+

%%

[ \t]       {}
{digits}    {yylval.val_int = std::atoi(yytext); return T_INT;}
\+          {return T_PLUS;}
\*          {return T_TIMES;}
\n          {return T_LINE;}
.           {yyerror(yytext);}

%%

void yyerror(const char* s){
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::fprintf(stderr, s);
}
