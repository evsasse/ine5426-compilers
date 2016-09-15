%{
  #include <iostream>

  extern int yylex();
  extern void yyerror(const char*);
%}

%union {
  int val_int;
}

%token<val_int> T_INT

%%

integer : T_INT { std::cout << $1 << std::endl; }
;

%%
