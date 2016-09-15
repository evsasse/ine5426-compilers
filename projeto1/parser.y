%{
  #include <iostream>

  extern int yylex();
  extern void yyerror(const char*);
%}

%union {
  int val_int;
  char* val_str;
}

%token <val_str> T_IDENTIFIER
%token T_NEWLINE
%left T_PLUS T_MINUS
%left T_TIMES T_DIVIDE
%token T_POPEN T_PCLOSE
%token T_ATTRIB T_COMMA

// V_ for values
%token <val_int> V_INT
// D_ for declarations
%token D_INT

%type <val_int> expr

%%

program :
        | program line
;
line    : T_NEWLINE
        | declaration T_NEWLINE
        | attribution T_NEWLINE
;

declaration : D_INT decl-items
;
decl-items  : decl-items T_COMMA decl-item
            | decl-item
;
decl-item   : T_IDENTIFIER
            | T_IDENTIFIER T_ATTRIB V_INT
;

attribution : T_IDENTIFIER T_ATTRIB expr
;

expr  : V_INT
      | T_IDENTIFIER
      | T_POPEN expr T_PCLOSE
      | T_MINUS expr
      | expr T_PLUS expr
      | expr T_MINUS expr
      | expr T_TIMES expr
      | expr T_DIVIDE expr
;

%%
