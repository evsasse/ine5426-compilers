#include <iostream>

#include "ast.h"

void IntegerNode::print(){
  //std::cout << "IntegerNode{";
  std::cout << " " << value;
  //std::cout << "}";
}
void FloatNode::print(){
  std::cout << " " << as_declared;
}
void BoolNode::print(){
  std::cout << " ";
  if(value)
    std::cout << "true";
  else
    std::cout << "false";
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
    case AND: std::cout << " &"; break;
    case OR: std::cout << " |"; break;
    case EQUAL: std::cout << " =="; break;
    case DIFFERENT: std::cout << " !="; break;
    case GREATER: std::cout << " >"; break;
    case GREATEROREQUAL: std::cout << " >="; break;
    case LESS: std::cout << " <"; break;
    case LESSOREQUAL: std::cout << " <="; break;
  }
  left->print();
  right->print();
  //std::cout << "}";
}

void UnaryOperationNode::print(){
  //std::cout << " -u";
  switch(operation){
    case NEGATIVE: std::cout << " -u"; break;
    case NOT: std::cout << " !"; break;
  }
  right->print();
}

void IdentifierNode::print(){
  //std::cout << "IdentifierNode{";
  std::cout << " " << name;
  //std::cout << name;
  //std::cout << "}";
}

// void MainIntegerDeclarationNode::print(){
//   //std::cout << "MainIntegerDeclarationNode{";
//   //std::cout << "int var: ";
//   std::cout << "int var:";
//   next->print();
//   //std::cout << "}";
// }
// void IntegerDeclarationNode::print(){
//   //std::cout << "IntegerDeclarationNode{";
//   //std::cout << "[" << identifier << "]";
//   //std::cout << identifier;
//   identifier->print();
//   if(next){
//     //std::cout << ", ";
//     std::cout << ",";
//     next->print();
//   }
//   //std::cout << "}";
// }
// void IntegerInitializationNode::print(){
//   //std::cout << "IntegerInitializationNode{";
//   //std::cout << "[" << identifier << "] = " << value;
//   //std::cout << identifier << " = " << value;
//   identifier->print();
//   std::cout << " = " << value;
//   if(next){
//     //std::cout << ", ";
//     std::cout << ",";
//     next->print();
//   }
//   //std::cout << "}";
//}

void MainDeclarationNode::print(){
  switch(type){
    case INT: std::cout << "int var:"; break;
    case FLOAT: std::cout << "float var:"; break;
    case BOOL: std::cout << "bool var:"; break;
  }
  first->print();
}
void DeclarationNode::print(){
  identifier->print();
  if(value){
    std::cout << " =";
    value->print();
  }
  if(next){
    std::cout << ",";
    next->print();
  }
}
