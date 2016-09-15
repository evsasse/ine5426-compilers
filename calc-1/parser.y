%{
  #include <iostream>

  extern int yylex();
  extern void yyerror(const char*);
%}

%union {
  int val_int;
}

%token <val_int> T_INT
%token T_PLUS T_TIMES T_LINE

%type <val_int> expr

%%

calc  :
      | calc line
;

line  : T_LINE
      | expr T_LINE { std::cout << "Result = " << $1 << std::endl; }
;

expr  : T_INT
      | expr T_PLUS expr { $$ = $1 + $3; }
      | expr T_TIMES expr { $$ = $1 * $3; }
;

%%
