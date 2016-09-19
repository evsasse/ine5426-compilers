#pragma once

#include <string>

enum Operation { NEGATIVE, NOT,
                 ATTRIB, PLUS, MINUS, TIMES, DIVIDE,
                 AND, OR, EQUAL, DIFFERENT, GREATER, GREATEROREQUAL,
                 LESS, LESSOREQUAL };
enum ValueType { INT, FLOAT, BOOL };

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
class FloatNode : public Node {
public:
  float value;
  FloatNode(float value) : value(value) {};
  void print();
};
class BoolNode : public Node {
public:
  bool value;
  BoolNode(bool value) : value(value) {};
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
  Operation operation;
  Node *right;
  UnaryOperationNode(Operation operation, Node *right) :
    operation(operation), right(right) {};
  void print();
};

class IdentifierNode : public Node {
public:
  std::string name;
  IdentifierNode(std::string name) : name(name) {};
  void print();
};

// class IntegerDeclarationNode : public Node {
// public:
//   IdentifierNode* identifier;
//   IntegerDeclarationNode *next;
//   IntegerDeclarationNode(IdentifierNode* identifier, IntegerDeclarationNode *next) :
//   identifier(identifier), next(next) {};
//   void print();
// };
// class IntegerInitializationNode : public IntegerDeclarationNode {
// public:
//   int value;
//   IntegerInitializationNode(IdentifierNode* identifier,
//     int value,
//     IntegerDeclarationNode *next) :
//     IntegerDeclarationNode(identifier, next), value(value) {};
//   void print();
// };
// class MainIntegerDeclarationNode : public Node {
// public:
//   IntegerDeclarationNode *next;
//   MainIntegerDeclarationNode(IntegerDeclarationNode *next): next(next) {};
//   void print();
//};

//template <class T>
// class DeclarationNode : public Node {
// public:
//   IdentifierNode *identifier;
//   DeclarationNode *next;
//   DeclarationNode(IdentifierNode* identifier, DeclarationNode *next = nullptr) :
//     identifier(identifier), next(next) {};
//   void print();
// }
//template <class T>
class DeclarationNode : public Node {
public:
  IdentifierNode *identifier;
  DeclarationNode *next;
  Node *value;
  DeclarationNode(IdentifierNode* identifier, Node* value = nullptr, DeclarationNode *next = nullptr) :
    identifier(identifier), value(value), next(next) {};
  void print();
};
class MainDeclarationNode : public Node {
public:
  ValueType type;
  DeclarationNode *first;
  MainDeclarationNode(DeclarationNode *first, ValueType type) :
    first(first), type(type) {};
  void print();
};
