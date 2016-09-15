%{
  #include <iostream>
  #include "parser.h"

  void lexical_error(const char*);
  void yyerror(const char*);
%}

%option noyywrap

integer [0-9]+

%%

[ \t\n]       { }
{integer}     { yylval.val_int = std::atoi(yytext); return T_INT; }
.+            { lexical_error(yytext); }

%%

void lexical_error(const char* s){
  std::cerr << "[Line " << yylineno << "] lexical error: unknown symbol "
  << s << std::endl;
}

void yyerror(const char*){
  std::cerr << "[Line " << yylineno << "] syntax error" << std::endl;
}
