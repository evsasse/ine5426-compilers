%{
  #include <iostream>
  #include "ast.h"
  #include "parser.h"

  void lexical_error(const char*);
  void yyerror(const char*);
%}

%option noyywrap yylineno

integer [0-9]+
float ([0-9]+"."[0-9]*)|([0-9]*"."[0-9]+)
bool "true"|"false"
identifier [a-zA-Z][a-zA-Z_0-9]*

%%

[ \t]         { }

{integer}     { yylval.val_int = std::atoi(yytext); return V_INT; }
{float}       { yylval.val_str = strdup(yytext); return V_FLOAT; }
{bool}        { yylval.val_bool = strcmp("true",yytext) == 0; return V_BOOL; }
{identifier}  { yylval.val_str = strdup(yytext); return T_IDENTIFIER; }

"int"[ \t]    { return D_INT; }
"float"[ \t]    { return D_FLOAT; }
"bool"[ \t]    { return D_BOOL; }

"fun"[ \t]    { return D_FUN; }
"ret"[ \t]    { return T_RET; }

"if"[ \t]     { return T_IF; }
"then"[ \t]   { return T_THEN; }
"else"[ \t]   { return T_ELSE; }
"for"[ \t]   { return T_FOR; }
"{"           { return T_CBOPEN; }
"}"           { return T_CBCLOSE; }

"[int]"       { return T_INT; }
"[float]"       { return T_FLOAT; }
"[bool]"       { return T_BOOL; }
"+"           { return T_PLUS; }
"-"           { return T_MINUS; }
"*"           { return T_TIMES; }
"/"           { return T_DIVIDE; }
"("           { return T_POPEN; }
")"           { return T_PCLOSE; }
"="           { return T_ATTRIB; }
","           { return T_COMMA; }
"=="          { return T_EQUAL; }
"!="          { return T_DIFFERENT; }
">"           { return T_GREATER; }
">="          { return T_GREATEROREQUAL; }
"<"           { return T_LESS; }
"<="          { return T_LESSOREQUAL; }
"&"           { return T_AND; }
"|"           { return T_OR; }
"!"           { return T_NOT; }
\n            { return T_NEWLINE; }

[^a-zA-Z0-9\. \t\{\}\[\]\+\-\*\/\(\)\=\,\!\>\<\&\|\n]+ { lexical_error(yytext); }

%%

void lexical_error(const char *s){
  std::cerr << "[Line " << yylineno << "] lexical error: unknown symbol "
    << s << std::endl;
}

void yyerror(const char *s){
  std::cerr << "[Line " << yylineno << "] " << s << std::endl;
}
