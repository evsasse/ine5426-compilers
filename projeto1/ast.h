#pragma once

enum Operation : char { PLUS='+', MINUS='-', TIMES='*', DIVIDE='/', ATTRIB='=' };

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

class IdentifierNode : public Node {
public:
  const char *name;
  IdentifierNode(const char *name) : name(name) {};
  void print();
};

class IntegerDeclarationNode : public Node {
public:
  const char *identifier;
  IntegerDeclarationNode *next;
  IntegerDeclarationNode(const char *identifier, IntegerDeclarationNode *next) :
  identifier(identifier), next(next) {};
  void print();
};
class IntegerInitializationNode : public IntegerDeclarationNode {
public:
  int value;
  IntegerInitializationNode(const char *identifier,
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
