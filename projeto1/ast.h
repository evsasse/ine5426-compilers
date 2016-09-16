#pragma once

#include <string>

enum Operation { PLUS, MINUS, TIMES, DIVIDE, ATTRIB };

class Node {
public:
  virtual void print(){};
};

class IntegerNode : public Node {
public:
  int value;
  IntegerNode(int value) : value(value) {};
  void print();
};

class BinaryOperationNode : public Node {
public:
  Operation operation;
  Node *left, *right;
  BinaryOperationNode(Node *left, Operation operation, Node *right) :
    left(left), operation(operation), right(right) {};
  void print();
};

class UnaryOperationNode : public Node {
public:
  Node *right;
  UnaryOperationNode(Node *right) :
    right(right) {};
  void print();
};

class IdentifierNode : public Node {
public:
  std::string name;
  IdentifierNode(std::string name) : name(name) {};
  void print();
};

class IntegerDeclarationNode : public Node {
public:
  std::string identifier;
  IntegerDeclarationNode *next;
  IntegerDeclarationNode(std::string identifier, IntegerDeclarationNode *next) :
  identifier(identifier), next(next) {};
  void print();
};
class IntegerInitializationNode : public IntegerDeclarationNode {
public:
  int value;
  IntegerInitializationNode(std::string identifier,
    int value,
    IntegerDeclarationNode *next) :
    IntegerDeclarationNode(identifier, next), value(value) {};
  void print();
};
class MainIntegerDeclarationNode : public Node {
public:
  IntegerDeclarationNode *next;
  MainIntegerDeclarationNode(IntegerDeclarationNode *next): next(next) {};
  void print();
};
