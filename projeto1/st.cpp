#include "st.h"

extern void yyerror(const char*);

IdentifierNode* SymbolTable::newSymbol(std::string name){
  if(table.find(name) != table.end()){
    yyerror("semantic error: re-declaration of variable");
  }else{
    table[name] = new IdentifierNode(name);
  }
  return table[name];
}

IdentifierNode* SymbolTable::useSymbol(std::string name){
  if(table.find(name) == table.end()){
    yyerror("semantic error: undeclared variable");
    return nullptr;
  }else{
    return table[name];
  }
}
