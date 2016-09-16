#include <iostream>

#include "ast.h"

void IntegerNode::print(){
  //std::cout << "IntegerNode{";
  std::cout << " " << value;
  //std::cout << "}";
}

void BinaryOperationNode::print(){
  //std::cout << "BinaryOperationNode{";
  //left->print();
  switch(operation){
    case PLUS: std::cout << " +"; break;
    case MINUS: std::cout << " -"; break;
    case TIMES: std::cout << " *"; break;
    case DIVIDE: std::cout << " /"; break;
    case ATTRIB: std::cout << "="; break;
  }
  left->print();
  right->print();
  //std::cout << "}";
}

void UnaryOperationNode::print(){
  std::cout << " -u";
  right->print();
}

void IdentifierNode::print(){
  //std::cout << "IdentifierNode{";
  std::cout << " " << name;
  //std::cout << "}";
}

void MainIntegerDeclarationNode::print(){
  //std::cout << "MainIntegerDeclarationNode{";
  std::cout << "int var: ";
  next->print();
  //std::cout << "}";
}
void IntegerDeclarationNode::print(){
  //std::cout << "IntegerDeclarationNode{";
  //std::cout << "[" << identifier << "]";
  std::cout << identifier;
  if(next){
    std::cout << ", ";
    next->print();
  }
  //std::cout << "}";
}
void IntegerInitializationNode::print(){
  //std::cout << "IntegerInitializationNode{";
  //std::cout << "[" << identifier << "] = " << value;
  std::cout << identifier << " = " << value;
  if(next){
    std::cout << ", ";
    next->print();
  }
  //std::cout << "}";
}
