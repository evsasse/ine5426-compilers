#pragma once

#include <map>
#include "ast.h"

class SymbolTable{
public:
  std::map<std::string,IdentifierNode*> table;
  IdentifierNode* newSymbol(std::string name, ValueType type);
  IdentifierNode* useSymbol(std::string name);
};
