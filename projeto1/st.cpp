#include "st.h"

extern void yyerror(const char*);

IdentifierNode* SymbolTable::newSymbol(std::string name, ValueType type, Node* params){
  if(table.find(name) != table.end()){
    yyerror("semantic error: re-declaration of variable");
  }else{
    table[name] = new IdentifierNode(name,type);
  }
  return table[name];
}

IdentifierNode* SymbolTable::useSymbol(std::string name, Node* values){
  if(!previous && table.find(name) == table.end()){
    yyerror("semantic error: undeclared variable");
    return nullptr;
  } else if(table.find(name) == table.end()){
    return previous->useSymbol(name);
  }else{
    return table[name];
  }
}
