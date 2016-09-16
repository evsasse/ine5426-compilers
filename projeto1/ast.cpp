#include <iostream>

#include "ast.h"

void IntegerNode::print(){
  std::cout << value;
}

void BinaryOperationNode::print(){
  left->print();
  std::cout << operation;
  right->print();
}

void IdentifierNode::print(){
  std::cout << name;
}

void MainIntegerDeclarationNode::print(){
  std::cout << "int var: ";
  next->print();
}
void IntegerDeclarationNode::print(){
  std::cout << identifier;
  if(next){
    std::cout << ", ";
    next->print();
  }
}
void IntegerInitializationNode::print(){
  std::cout << identifier << " = " << value;
  if(next){
    std::cout << ", ";
    next->print();
  }
}
