%{
  #include <list>
  #include "ast.h"

  extern int yylex();
  extern void yyerror(const char*);

  std::list<Node*> lines;
%}

%union {
  int val_int;
  const char *val_str;
  Node *node;
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

%type <node> line declaration decl-items decl-item attribution expr

%%

program :
        | program line { lines.push_back($2); }
;
// adds a new Node, for each line with content, to the NodeList.
// the node to be added is returned by the content.
line    : T_NEWLINE { $$ = nullptr; }
        | declaration T_NEWLINE
        | attribution T_NEWLINE
;

declaration : D_INT decl-items { $$ = new MainIntegerDeclarationNode(static_cast<IntegerDeclarationNode*>($2)); }
;
decl-items  : decl-items T_COMMA decl-item { static_cast<IntegerDeclarationNode*>($1)->next = static_cast<IntegerDeclarationNode*>($3); }
            | decl-item
;
decl-item   : T_IDENTIFIER { $$ = new IntegerDeclarationNode($1, nullptr); }
            | T_IDENTIFIER T_ATTRIB V_INT { $$ = new IntegerInitializationNode($1, $3, nullptr);}
;

attribution : T_IDENTIFIER T_ATTRIB expr { $$ = new BinaryOperationNode(new IdentifierNode($1), ATTRIB, $3); }
;

expr  : V_INT { $$ = new IntegerNode($1); }
      | T_IDENTIFIER { $$ = new IdentifierNode($1); }
      | T_POPEN expr T_PCLOSE { $$ = $2; }
      | T_MINUS expr { $$ = new BinaryOperationNode(new IntegerNode(0), MINUS, $2); }
      | expr T_PLUS expr { $$ = new BinaryOperationNode($1, PLUS, $3); }
      | expr T_MINUS expr { $$ = new BinaryOperationNode($1, MINUS, $3); }
      | expr T_TIMES expr { $$ = new BinaryOperationNode($1, TIMES, $3); }
      | expr T_DIVIDE expr { $$ = new BinaryOperationNode($1, DIVIDE, $3); }
;

%%
