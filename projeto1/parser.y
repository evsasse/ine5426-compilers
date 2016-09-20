%{
  #include <list>
  #include "ast.h"
  #include "st.h"

  extern int yylex();
  extern void yyerror(const char*);

  std::list<Node*> lines;
  SymbolTable symbolTable;
%}

%union {
  int val_int;
  float val_float;
  bool val_bool;
  const char *val_str;
  Node *node;
}

//%token <val_str> T_LEXERROR

%token <val_str> T_IDENTIFIER
%token T_NEWLINE
//tokens for expressions
%token T_POPEN T_PCLOSE
%token T_ATTRIB T_COMMA
//tokens for integer and float operations
%left T_PLUS T_MINUS
%left T_TIMES T_DIVIDE
//tokens for boolean operations
%left T_AND T_OR
%left T_EQUAL T_DIFFERENT
%left T_GREATER T_GREATEROREQUAL T_LESS T_LESSOREQUAL
%left T_NOT

// V_ for values
%token <val_int> V_INT
//%token <val_float> V_FLOAT
%token <val_str> V_FLOAT
%token <val_bool> V_BOOL
// D_ for declarations
%token D_INT
%token D_FLOAT
%token D_BOOL

%type <node> line declaration decl-items decl-value decl-item attribution expr

%%

program :
        | program line { lines.push_back($2); }
        | program T_NEWLINE
;
// adds a new Node, for each line with content, to the NodeList.
// the node to be added is returned by the content.
//anything: anything anything
//        | T_IDENTIFIER | T_POPEN | T_PCLOSE | T_ATTRIB | T_COMMA
//        | T_PLUS | T_MINUS | T_TIMES | T_DIVIDE | T_AND | T_OR
//        | T_EQUAL | T_DIFFERENT | T_GREATER | T_GREATEROREQUAL
//        | T_LESS | T_LESSOREQUAL | T_NOT
//        | V_INT | V_FLOAT | V_BOOL | D_INT | D_FLOAT | D_BOOL
//;
line    : declaration T_NEWLINE
        | attribution T_NEWLINE
//        | anything T_LEXERROR anything T_NEWLINE { yyerror("lexical error: unknown symbol"); }
;

//declaration : D_INT decl-items { $$ = new MainIntegerDeclarationNode(static_cast<IntegerDeclarationNode*>($2)); }
//;
//decl-items  : decl-item T_COMMA decl-items { static_cast<IntegerDeclarationNode*>($1)->next = static_cast<IntegerDeclarationNode*>($3); }
//            | decl-item
//;
//decl-item   : T_IDENTIFIER { $$ = new IntegerDeclarationNode(symbolTable.newSymbol($1), nullptr); }
//            | T_IDENTIFIER T_ATTRIB V_INT { $$ = new IntegerInitializationNode(symbolTable.newSymbol($1), $3, nullptr);}
//;

declaration : D_INT decl-items { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), INT); }
            | D_FLOAT decl-items { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), FLOAT); }
            | D_BOOL decl-items { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), BOOL); }
;
decl-items  : decl-item T_COMMA decl-items { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-item
;
decl-value  : V_INT { $$ = new IntegerNode($1); }
            | V_FLOAT { $$ = new FloatNode($1); }
            | V_BOOL { $$ = new BoolNode($1); }
;
decl-item   : T_IDENTIFIER { $$ = new DeclarationNode(symbolTable.newSymbol($1)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(symbolTable.newSymbol($1), $3); }

attribution : T_IDENTIFIER T_ATTRIB expr { $$ = new BinaryOperationNode(symbolTable.useSymbol($1), ATTRIB, $3); }
;

expr  : V_INT { $$ = new IntegerNode($1); }
      | V_FLOAT { $$ = new FloatNode($1); }
      | V_BOOL { $$ = new BoolNode($1); }
      | T_IDENTIFIER { $$ = symbolTable.useSymbol($1); }
      | T_POPEN expr T_PCLOSE { $$ = $2; }
      | T_MINUS expr { $$ = new UnaryOperationNode(NEGATIVE, $2); }
      | T_NOT expr { $$ = new UnaryOperationNode(NOT, $2); }
      | expr T_PLUS expr { $$ = new BinaryOperationNode($1, PLUS, $3); }
      | expr T_MINUS expr { $$ = new BinaryOperationNode($1, MINUS, $3); }
      | expr T_TIMES expr { $$ = new BinaryOperationNode($1, TIMES, $3); }
      | expr T_DIVIDE expr { $$ = new BinaryOperationNode($1, DIVIDE, $3); }
      | expr T_AND expr { $$ = new BinaryOperationNode($1, AND, $3); }
      | expr T_OR expr { $$ = new BinaryOperationNode($1, OR, $3); }
      | expr T_EQUAL expr { $$ = new BinaryOperationNode($1, EQUAL, $3); }
      | expr T_DIFFERENT expr { $$ = new BinaryOperationNode($1, DIFFERENT, $3); }
      | expr T_GREATER expr { $$ = new BinaryOperationNode($1, GREATER, $3); }
      | expr T_GREATEROREQUAL expr { $$ = new BinaryOperationNode($1, GREATEROREQUAL, $3); }
      | expr T_LESS expr { $$ = new BinaryOperationNode($1, LESS, $3); }
      | expr T_LESSOREQUAL expr { $$ = new BinaryOperationNode($1, LESSOREQUAL, $3); }
;

%%
