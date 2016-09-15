%{
  #include <iostream>

  extern int yylex();
  extern void yyerror(const char*);
%}

%union {
  double val_double;
}

%token <val_double> T_DOUBLE
%left T_PLUS T_MINUS
%left T_TIMES T_DIVIDE
%token T_POPEN T_PCLOSE
%token T_NEWLINE T_EXIT

%type <val_double> expr

%%

calc  :
      | calc line
;

line  : T_NEWLINE
      | expr T_NEWLINE { std::cout << "Result = " << $1 << std::endl; }
      | T_EXIT T_NEWLINE { exit(0); }
;

expr  : T_DOUBLE
      | T_POPEN expr T_PCLOSE { $$ = $2; }
      | T_MINUS expr { $$ = -$2; }
      | expr T_PLUS expr { $$ = $1 + $3; }
      | expr T_MINUS expr { $$ = $1 - $3; }
      | expr T_TIMES expr { $$ = $1 * $3; }
      | expr T_DIVIDE expr { $$ = $1 / $3; }
;

%%
