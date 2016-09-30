#pragma once

#include <map>
#include "ast.h"

class SymbolTable{
public:
  SymbolTable* previous;
  SymbolTable(SymbolTable* previous = nullptr) :
    previous(previous) {};
  std::map<std::string,IdentifierNode*> table;
  IdentifierNode* newSymbol(std::string name, ValueType type, Node *value = nullptr, ListNode *params = nullptr);
  IdentifierNode* useSymbol(std::string name);
  SymbolTable* endScope();
};
