%{
  #include <list>
  #include "ast.h"
  #include "st.h"

  extern int yylex();
  extern void yyerror(const char*);

  BlockNode lines;
  SymbolTable symbolTable;
%}

%union {
  int val_int;
  float val_float;
  bool val_bool;
  const char *val_str;
  Node *node;
  BlockNode *block;
}

%token <val_str> T_IDENTIFIER
%token T_NEWLINE

%token T_POPEN T_PCLOSE
%token T_ATTRIB T_COMMA

%token T_IF T_THEN T_ELSE T_FOR
%token T_CBOPEN T_CBCLOSE

//tokens for boolean operations
%left T_AND T_OR
%left T_EQUAL T_DIFFERENT
%left T_GREATER T_GREATEROREQUAL T_LESS T_LESSOREQUAL
%left T_NOT

//tokens for math operations
%left T_INT T_FLOAT T_BOOL
%left T_PLUS T_MINUS
%left T_TIMES T_DIVIDE
%nonassoc T_UNARYMINUS

// V_ for values
%token <val_int> V_INT
%token <val_str> V_FLOAT
%token <val_bool> V_BOOL

// D_ for declarations
%token D_INT
%token D_FLOAT
%token D_BOOL

%type <node> ifthenelse for for-init for-iter
%type <node> line declaration decl-value
%type <node> decl-ints decl-int
%type <node> decl-floats decl-float
%type <node> decl-bools decl-bool
%type <node> attribution expr
%type <block> block else

%%

program : block { lines = *$1; }
;
block   : { $$ = new BlockNode(); }
        | block line { $1->push_back($2); }
        | block T_NEWLINE
;

line    : declaration T_NEWLINE
        | attribution T_NEWLINE
        | ifthenelse T_NEWLINE
        | for T_NEWLINE
;

declaration : D_INT decl-ints { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), INT); }
            | D_FLOAT decl-floats { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), FLOAT); }
            | D_BOOL decl-bools { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), BOOL); }
;
decl-value  : V_INT { $$ = new IntegerNode($1); }
            | V_FLOAT { $$ = new FloatNode($1); }
            | V_BOOL { $$ = new BoolNode($1); }
;
decl-ints   : decl-int T_COMMA decl-ints { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-int
;
decl-int    : T_IDENTIFIER { $$ = new DeclarationNode(symbolTable.newSymbol($1,INT)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(symbolTable.newSymbol($1,INT), $3); }
;
decl-floats : decl-float T_COMMA decl-floats { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-float
;
decl-float  : T_IDENTIFIER { $$ = new DeclarationNode(symbolTable.newSymbol($1,FLOAT)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(symbolTable.newSymbol($1,FLOAT), $3); }
;
decl-bools  : decl-bool T_COMMA decl-bools { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-bool
;
decl-bool   : T_IDENTIFIER { $$ = new DeclarationNode(symbolTable.newSymbol($1,BOOL)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(symbolTable.newSymbol($1,BOOL), $3); }
;

attribution : T_IDENTIFIER T_ATTRIB expr { $$ = new BinaryOperationNode(symbolTable.useSymbol($1), ATTRIB, $3); }
;

ifthenelse  : T_IF expr T_NEWLINE T_THEN T_CBOPEN T_NEWLINE block T_CBCLOSE else { $$ = new IfThenElseNode($2, $7, $9); }
;
else        : { $$ = nullptr; }
            | T_ELSE T_CBOPEN T_NEWLINE block T_CBCLOSE { $$ = $4; }
;
for         : T_FOR for-init T_COMMA expr T_COMMA for-iter T_CBOPEN T_NEWLINE block T_CBCLOSE { $$ = new ForNode($2, $4, $6, $9); }
;
for-init    : { $$ = nullptr; }
            | attribution
;
for-iter    : { $$ = nullptr; }
            | attribution
;

expr  : V_INT { $$ = new IntegerNode($1); }
      | V_FLOAT { $$ = new FloatNode($1); }
      | V_BOOL { $$ = new BoolNode($1); }
      | T_IDENTIFIER { $$ = symbolTable.useSymbol($1); }
      | T_POPEN expr T_PCLOSE { $$ = $2; }
      | T_INT expr { $$ = new UnaryOperationNode(CINT, $2); }
      | T_FLOAT expr { $$ = new UnaryOperationNode(CFLOAT, $2); }
      | T_BOOL expr { $$ = new UnaryOperationNode(CBOOL, $2); }
      | T_MINUS expr %prec T_UNARYMINUS { $$ = new UnaryOperationNode(NEGATIVE, $2); }
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
