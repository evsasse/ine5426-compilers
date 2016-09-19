#pragma once

#include <map>
#include "ast.h"

class SymbolTable{
public:
  std::map<std::string,IdentifierNode*> table;
  IdentifierNode* newSymbol(std::string name);
  IdentifierNode* useSymbol(std::string name);
};
