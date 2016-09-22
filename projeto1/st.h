#pragma once

#include <map>
#include "ast.h"

class SymbolTable{
public:
  SymbolTable* previous;
  SymbolTable(SymbolTable* previous = nullptr) :
    previous(previous) {};
  std::map<std::string,IdentifierNode*> table;
  IdentifierNode* newSymbol(std::string name, ValueType type);
  IdentifierNode* useSymbol(std::string name);
};
