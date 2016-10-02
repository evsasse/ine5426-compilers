%{
  #include <list>
  #include "ast.h"
  #include "st.h"

  extern int yylex();
  extern void yyerror(const char*);

  BlockNode lines;
  SymbolTable *currentSymbolTable;
%}

//%define parse.error verbose

%union {
  int val_int;
  float val_float;
  bool val_bool;
  const char *val_str;
  Node *node;
  BlockNode *block;
  ListNode *values;
}

%token <val_str> T_IDENTIFIER
%token T_NEWLINE
%token T_RET

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
%left T_REF T_ADDR
%nonassoc T_UNARYMINUS

// V_ for values
%token <val_int> V_INT
%token <val_str> V_FLOAT
%token <val_bool> V_BOOL

// D_ for declarations
%token D_INT
%token D_FLOAT
%token D_BOOL
%token D_FUN

%type <node> ifthenelse for for-init for-iter
%type <node> line declaration decl-value
%type <node> decl-ints decl-int decl-int-opts decl-arr-int
%type <node> decl-floats decl-float decl-float-opts decl-arr-float
%type <node> decl-bools decl-bool decl-bool-opts decl-arr-bool
%type <node> attribution expr
%type <values> exprs func-params params
%type <values> decl-arr-ints decl-arr-floats decl-arr-bools
%type <node> param
%type <block> block scoped-block else func-def
%type <val_int> refs

%%

program : scoped-block { lines = *$1; }
;
scoped-block : { currentSymbolTable = new SymbolTable(currentSymbolTable); } block { currentSymbolTable = currentSymbolTable->endScope(); $$ = $2; }
;
block   : %empty { $$ = new BlockNode(); }
        | block line { $1->push_back($2); }
        | block error T_NEWLINE { yyerrok; }
        | block T_NEWLINE
;

line    : declaration T_NEWLINE
        | attribution T_NEWLINE
        | ifthenelse T_NEWLINE
        | for T_NEWLINE
;

declaration : D_INT decl-int-opts { $$ = $2; }
            | D_FLOAT decl-float-opts { $$ = $2; }
            | D_BOOL decl-bool-opts { $$ = $2; }
;
decl-value  : V_INT { $$ = new IntegerNode($1); }
            | V_FLOAT { $$ = new FloatNode($1); }
            | V_BOOL { $$ = new BoolNode($1); }
;

refs    : T_REF { $$ = 1; }
        | refs T_REF { $$ = $1 + 1; }
;

decl-int-opts : D_FUN T_IDENTIFIER T_POPEN { currentSymbolTable = new SymbolTable(currentSymbolTable); }
                func-params T_PCLOSE func-def { currentSymbolTable = currentSymbolTable->endScope(); $$ = new FunctionDeclarationNode(currentSymbolTable->newSymbol($2,INT,$7,$5),$5,$7); }
              | decl-ints { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($1), INT); }
              | decl-arr-ints { $$ = new ArrayDeclarationNode($1,INT); }
              | refs decl-arr-ints { for(Node *node : *$2){ static_cast<IdentifierNode*>(node)->refs = $1; }; $$ = new ArrayDeclarationNode($2,INT); }
              | refs decl-ints { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($2), INT, $1); }
;
decl-ints   : decl-int T_COMMA decl-ints { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-int
;
decl-int    : T_IDENTIFIER { $$ = new DeclarationNode(currentSymbolTable->newSymbol($1,INT)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(currentSymbolTable->newSymbol($1,INT), $3); }
;
decl-arr-ints : decl-arr-int { $$ = new ListNode(); $$->push_back($1); }
              | decl-arr-ints T_COMMA decl-arr-int { $1->push_back($3); }
;
decl-arr-int  : T_IDENTIFIER T_POPEN V_INT T_PCLOSE { $$ = currentSymbolTable->newSymbol($1,INT,new IntegerNode($3)); }
;

decl-float-opts : D_FUN T_IDENTIFIER T_POPEN { currentSymbolTable = new SymbolTable(currentSymbolTable); }
                  func-params T_PCLOSE func-def { currentSymbolTable = currentSymbolTable->endScope(); $$ = new FunctionDeclarationNode(currentSymbolTable->newSymbol($2,FLOAT,$7,$5),$5,$7); }
                | decl-floats { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($1), FLOAT); }
                | decl-arr-floats { $$ = new ArrayDeclarationNode($1,FLOAT); }
;
decl-floats : decl-float T_COMMA decl-floats { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-float
;
decl-float  : T_IDENTIFIER { $$ = new DeclarationNode(currentSymbolTable->newSymbol($1,FLOAT)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(currentSymbolTable->newSymbol($1,FLOAT), $3); }
;
decl-arr-floats : decl-arr-float { $$ = new ListNode(); $$->push_back($1); }
                | decl-arr-floats T_COMMA decl-arr-float { $1->push_back($3); }
;
decl-arr-float  : T_IDENTIFIER T_POPEN V_INT T_PCLOSE { $$ = currentSymbolTable->newSymbol($1,FLOAT,new IntegerNode($3)); }
;

decl-bool-opts: D_FUN T_IDENTIFIER T_POPEN { currentSymbolTable = new SymbolTable(currentSymbolTable); }
                func-params T_PCLOSE func-def { currentSymbolTable = currentSymbolTable->endScope(); $$ = new FunctionDeclarationNode(currentSymbolTable->newSymbol($2,BOOL,$7,$5),$5,$7); }
              | decl-bools { $$ = new MainDeclarationNode(static_cast<DeclarationNode*>($1), BOOL); }
              | decl-arr-bools { $$ = new ArrayDeclarationNode($1,BOOL); }
;
decl-bools  : decl-bool T_COMMA decl-bools { static_cast<DeclarationNode*>($1)->next = static_cast<DeclarationNode*>($3); }
            | decl-bool
;
decl-bool   : T_IDENTIFIER { $$ = new DeclarationNode(currentSymbolTable->newSymbol($1,BOOL)); }
            | T_IDENTIFIER T_ATTRIB decl-value { $$ = new DeclarationNode(currentSymbolTable->newSymbol($1,BOOL), $3); }
;
decl-arr-bools : decl-arr-bool { $$ = new ListNode(); $$->push_back($1); }
               | decl-arr-bools T_COMMA decl-arr-bool { $1->push_back($3); }
;
decl-arr-bool  : T_IDENTIFIER T_POPEN V_INT T_PCLOSE { $$ = currentSymbolTable->newSymbol($1,BOOL,new IntegerNode($3)); }
;

// get the parameters without allowing unecessary commas
func-params  : %empty { $$ = new ListNode(); }
             | params
;
params  : param { $$ = new ListNode(); $$->push_back($1); }
        | params T_COMMA param { $1->push_back($3); }
;
param   : D_INT T_IDENTIFIER { $$ = currentSymbolTable->newSymbol($2, INT);  }
        | D_FLOAT T_IDENTIFIER { $$ = currentSymbolTable->newSymbol($2, FLOAT); }
        | D_BOOL T_IDENTIFIER { $$ = currentSymbolTable->newSymbol($2, BOOL); }
;
func-def    : %empty { $$ = nullptr; }
            | T_CBOPEN block T_RET expr T_NEWLINE T_CBCLOSE { $2->push_back(new ReturnNode($4)); $$ = $2; }
;

attribution : T_IDENTIFIER T_ATTRIB expr { $$ = new BinaryOperationNode(currentSymbolTable->useSymbol($1), ATTRIB, $3); }
            | T_IDENTIFIER T_POPEN expr T_PCLOSE T_ATTRIB expr { $$ = new BinaryOperationNode(new ArrayUseNode(currentSymbolTable->useSymbol($1),$3),ATTRIB,$6); }
;

ifthenelse  : T_IF expr T_NEWLINE T_THEN T_CBOPEN T_NEWLINE scoped-block T_CBCLOSE else { $$ = new IfThenElseNode($2, $7, $9); }
;
else        : %empty { $$ = nullptr; }
            | T_ELSE T_CBOPEN T_NEWLINE scoped-block T_CBCLOSE { $$ = $4; }
;
for         : T_FOR for-init T_COMMA expr T_COMMA for-iter T_CBOPEN T_NEWLINE scoped-block T_CBCLOSE { $$ = new ForNode($2, $4, $6, $9); }
;
for-init    : %empty { $$ = nullptr; }
            | attribution
;
for-iter    : %empty { $$ = nullptr; }
            | attribution
;

exprs : expr { $$ = new ListNode(); $$->push_back($1); }
      | exprs T_COMMA expr { $1->push_back($3); }
;
expr  : V_INT { $$ = new IntegerNode($1); }
      | V_FLOAT { $$ = new FloatNode($1); }
      | V_BOOL { $$ = new BoolNode($1); }
      | T_IDENTIFIER { $$ = currentSymbolTable->useSymbol($1); }
      | T_IDENTIFIER T_POPEN T_PCLOSE { $$ = new FunctionCallNode(currentSymbolTable->useSymbol($1), new ListNode()); }
      | T_IDENTIFIER T_POPEN exprs T_PCLOSE { auto id = currentSymbolTable->useSymbol($1); $$ = (!id->params && $3->size() == 1)? static_cast<Node*>(new ArrayUseNode(id,*($3->begin()))) : static_cast<Node*>(new FunctionCallNode(id,$3)); }
      | T_POPEN expr T_PCLOSE { $$ = $2; }
      | T_INT expr { $$ = new UnaryOperationNode(CINT, $2); }
      | T_FLOAT expr { $$ = new UnaryOperationNode(CFLOAT, $2); }
      | T_BOOL expr { $$ = new UnaryOperationNode(CBOOL, $2); }
      | T_MINUS expr %prec T_UNARYMINUS { $$ = new UnaryOperationNode(NEGATIVE, $2); }
      | T_NOT expr { $$ = new UnaryOperationNode(NOT, $2); }
      | T_REF expr { $$ = new UnaryOperationNode(REF, $2); }
      | T_ADDR expr { $$ = new UnaryOperationNode(ADDR, $2); }
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
