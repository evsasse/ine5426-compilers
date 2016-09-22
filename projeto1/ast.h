#pragma once

#include <string>
#include <list>

enum Operation { NEGATIVE, NOT, CINT, CFLOAT, CBOOL,
                 ATTRIB, PLUS, MINUS, TIMES, DIVIDE,
                 AND, OR, EQUAL, DIFFERENT, GREATER, GREATEROREQUAL,
                 LESS, LESSOREQUAL };
enum ValueType { INT, FLOAT, BOOL };

class Node {
public:
  ValueType type;
  virtual void print(){};
  Node(){};
protected:
  Node(ValueType type) :
    type(type) {};
};

class BlockNode : public std::list<Node*>, public Node {
public:
  static int tabs;
  BlockNode() {};
  void print();
};

class IntegerNode : public Node {
public:
  int value;
  IntegerNode(int value) :
    Node(INT), value(value) {};
  void print();
};
class FloatNode : public Node {
public:
  std::string as_declared;
  float value;
  FloatNode(std::string value) :
    Node(FLOAT), as_declared(value), value(std::stof(value)) {};
  void print();
};
class BoolNode : public Node {
public:
  bool value;
  BoolNode(bool value) :
    Node(BOOL), value(value) {};
  void print();
};

class BinaryOperationNode : public Node {
public:
  Operation operation;
  Node *left, *right;
  BinaryOperationNode(Node *left, Operation operation, Node *right);
  void print();
};
class UnaryOperationNode : public Node {
public:
  Operation operation;
  Node *right;
  UnaryOperationNode(Operation operation, Node *right);
  void print();
};

class IdentifierNode : public Node {
public:
  std::string name;
  IdentifierNode(std::string name, ValueType type) :
    Node(type), name(name) {};
  void print();
};

class DeclarationNode : public Node {
public:
  IdentifierNode *identifier;
  DeclarationNode *next;
  Node *value;
  DeclarationNode(IdentifierNode* identifier, Node* value = nullptr, DeclarationNode *next = nullptr);
  void print();
};
class MainDeclarationNode : public Node {
public:
  DeclarationNode *first;
  MainDeclarationNode(DeclarationNode *first, ValueType type) :
    Node(type), first(first) {};
  void print();
};

class IfThenElseNode : public Node {
public:
  Node* _if;
  BlockNode *then, *_else;
  IfThenElseNode(Node *_if, BlockNode *then, BlockNode *_else = nullptr);
  void print();
};

class ForNode : public Node {
public:
  Node *init, *test, *iter;
  BlockNode *block;
  ForNode(Node *init, Node *test, Node *iter, BlockNode *block);
  void print();
};
