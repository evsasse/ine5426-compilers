#include <iostream>
#include <iomanip>

#include "ast.h"

extern void yyerror(const char*);

std::string operationName(Operation op){
  switch(op){
    case ATTRIB: return "attribution"; break;
    case PLUS: return "addition"; break;
    case MINUS: return "subtraction"; break;
    case TIMES: return "multiplication"; break;
    case DIVIDE: return "division"; break;
    case NEGATIVE: return "unary minus"; break;
    case EQUAL: return "equal"; break;
    case DIFFERENT: return "different"; break;
    case GREATER: return "greater than"; break;
    case LESS: return "less than"; break;
    case GREATEROREQUAL: return "greater or equal than"; break;
    case LESSOREQUAL: return "less or equal than"; break;
    case AND: return "and"; break;
    case OR: return "or"; break;
    case NOT: return "negation"; break;
  }
};
std::string typeFullName(ValueType type){
  switch(type){
    case INT: return "integer"; break;
    case FLOAT: return "float"; break;
    case BOOL: return "boolean"; break;
  }
};
std::string typeName(ValueType type){
  switch(type){
    case INT: return "int"; break;
    case FLOAT: return "float"; break;
    case BOOL: return "bool"; break;
  }
};

int BlockNode::tabs = -1; //
void BlockNode::print(){
  //std::cout << "[";
  tabs++;
  for(Node *line : *this){
    if(FunctionDeclarationNode* func = dynamic_cast<FunctionDeclarationNode*>(line)){
      if(!func->block) continue; // ignores lines of function declaration
    }
    for(int i=0; i<tabs; i++)
      std::cout << "  ";
    line->print();
    if(line != this->back())
      std::cout << std::endl;
  }
  tabs--;
  //std::cout << "]";
}

void ReturnNode::print(){
  std::cout << "ret";
  expr->print();
}

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

BinaryOperationNode::BinaryOperationNode(Node *left, Operation operation, Node *right) :
Node(left->type), left(left), operation(operation), right(right) {
  if(operation == GREATER || operation == GREATEROREQUAL || operation == LESS || operation == LESSOREQUAL){
    //relational operation
    Node::type = BOOL;
    if(left->type == FLOAT && right->type == INT){
      this->right = new UnaryOperationNode(CFLOAT,right);
    }
    else if(left->type == INT && right->type == FLOAT){
      this->left = new UnaryOperationNode(CFLOAT,left);
    }
    else if(left->type != INT && left->type != FLOAT && right->type != INT && right->type != FLOAT){
      yyerror(("semantic error: "+operationName(operation)+" operation expected integer or float but received "+typeFullName(left->type)+" and "+typeFullName(right->type)).c_str());
    }
    else if(left->type != INT && left->type != FLOAT){
      yyerror(("semantic error: "+operationName(operation)+" operation expected "+typeFullName(right->type)+" but received "+typeFullName(left->type)).c_str());
    }
    else if(right->type != INT && right->type != FLOAT){
      yyerror(("semantic error: "+operationName(operation)+" operation expected "+typeFullName(left->type)+" but received "+typeFullName(right->type)).c_str());
    }
  }
  else if(operation == EQUAL || operation == DIFFERENT){
    //comparison operation
    Node::type = BOOL;
    if(left->type != right->type && !(left->type == INT && right->type == FLOAT) && !(left->type == FLOAT && right->type == INT)){
      yyerror(("semantic error: "+operationName(operation)+" operation expected "+typeFullName(left->type)+" but received "+typeFullName(right->type)).c_str());
    }
  }
  else if(operation == PLUS || operation == MINUS || operation == TIMES || operation == DIVIDE){
    //math operations
    if(left->type == FLOAT && right->type == INT){
      this->right = new UnaryOperationNode(CFLOAT,right);
    }
    else if(left->type == INT && right->type == FLOAT){
      Node::type = FLOAT;
      this->left = new UnaryOperationNode(CFLOAT,left);
    }
    else if(left->type != INT && left->type != FLOAT && right->type != INT && right->type != FLOAT){
      yyerror(("semantic error: "+operationName(operation)+" operation expected integer or float but received "+typeFullName(left->type)+" and "+typeFullName(right->type)).c_str());
    }
    else if(left->type != INT && left->type != FLOAT){
      yyerror(("semantic error: "+operationName(operation)+" operation expected "+typeFullName(right->type)+" but received "+typeFullName(left->type)).c_str());
    }
    else if(right->type != INT && right->type != FLOAT){
      yyerror(("semantic error: "+operationName(operation)+" operation expected "+typeFullName(left->type)+" but received "+typeFullName(right->type)).c_str());
    }
  }
  else if(operation == ATTRIB){
    //attribution operation
    if(left->type == FLOAT && right->type == INT){
      this-> right = new UnaryOperationNode(CFLOAT,right);
      return;
    }
    else if(left->type != right->type){
      yyerror(("semantic error: attribution operation expected "+typeFullName(left->type)+" but received "+typeFullName(right->type)).c_str());
    }
  }
  else if(operation == AND || operation == OR){
    //logical operations
    Node::type = BOOL;
    if(left->type != BOOL){
      yyerror(("semantic error: "+operationName(operation)+" operation expected boolean but received "+typeFullName(left->type)).c_str());
    }
    else if(right->type != BOOL){
      yyerror(("semantic error: "+operationName(operation)+" operation expected boolean but received "+typeFullName(right->type)).c_str());
    }
  }
};
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

UnaryOperationNode::UnaryOperationNode(Operation operation, Node *right) :
Node(right->type), operation(operation), right(right){
  if(operation == NEGATIVE && type != INT && type != FLOAT){
    Node::type = INT;
    yyerror("semantic error: unary minus operation expected integer or float but received boolean");
  }
  else if(operation == NOT && type != BOOL){
    Node::type = BOOL;
    yyerror(("semantic error: negation operation expected boolean but received "+typeFullName(right->type)).c_str());
  }
  else if(operation == CINT){
    Node::type = INT;
  }
  else if(operation == CFLOAT){
    Node::type = FLOAT;
  }
  else if(operation == CBOOL){
    Node::type = BOOL;
  }
};
void UnaryOperationNode::print(){
  switch(operation){
    case NEGATIVE: std::cout << " -u"; break;
    case NOT: std::cout << " !"; break;
    case CINT: std::cout << " [int]"; break;
    case CFLOAT: std::cout << " [float]"; break;
    case CBOOL: std::cout << " [bool]"; break;
  }
  right->print();
}

void IdentifierNode::print(){
  std::cout << " " << name;
  // if(params){
  //   std::cout << "[" << params->size() << " params]";
  //   params->print();
  // }
}

void MainDeclarationNode::print(){
  switch(type){
    case INT: std::cout << "int var:"; break;
    case FLOAT: std::cout << "float var:"; break;
    case BOOL: std::cout << "bool var:"; break;
  }
  first->print();
}

DeclarationNode::DeclarationNode(IdentifierNode* identifier, Node *value, DeclarationNode *next) :
identifier(identifier), value(value), next(next) {
  if(value && value->type == INT && identifier->type == FLOAT)
    this->value = new UnaryOperationNode(CFLOAT,value);
  else if(value && value->type != identifier->type)
    yyerror(("semantic error: declaration of "+identifier->name+" expected "+typeFullName(identifier->type)+" but received "+typeFullName(value->type)).c_str());
};
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

void ListNode::print(){
  for(Node *node : *this){
    node->print();
  }
}

void ParamNode::print(){
  switch(type){
    case INT: std::cout << "int "; break;
    case FLOAT: std::cout << "float "; break;
    case BOOL: std::cout << "bool "; break;
  }
  std::cout << name;
}

void FunctionDeclarationNode::print(){
  if(!block) return;
  switch(identifier->type){
    case INT: std::cout << "int "; break;
    case FLOAT: std::cout << "float "; break;
    case BOOL: std::cout << "bool "; break;
  }
  std::cout << "fun: ";
  std::cout << identifier->name << " (params: ";
  for(Node *node : *params){
    switch(node->type){
      case INT: std::cout << "int"; break;
      case FLOAT: std::cout << "float"; break;
      case BOOL: std::cout << "bool"; break;
    }
    node->print();
    if(node != params->back())
      std::cout << ", ";
  }
  std::cout << ")" << std::endl;
  block->print();
}

FunctionCallNode::FunctionCallNode(IdentifierNode *identifier, ListNode *values) :
identifier(identifier), values(values) {
  type = identifier->type;
  if(identifier->params->size() != values->size()){
    yyerror(("semantic error: function "+identifier->name+" expects "+std::to_string(identifier->params->size())+" parameters but received "+std::to_string(values->size())).c_str());
  }
  //yyerror(("semantic tip: function "+identifier->name+" expects "+std::to_string(identifier->params->size())+" parameters and received "+std::to_string(values->size())).c_str());

  auto i = identifier->params->begin();
  auto v = values->begin();
  // for(Node* i : (*identifier->params))
  //   yyerror(("semantic tip: "+typeFullName(i->type)).c_str());
  for(;i != identifier->params->end() && v != values->end(); ++i, ++v){
    if((*i)->type != (*v)->type)
      yyerror(("semantic error: parameter "+static_cast<IdentifierNode*>(*i)->name+" expected "+typeFullName((*i)->type)+" but received "+typeFullName((*v)->type)).c_str());
    // else
    //   yyerror(("semantic tip: parameter "+static_cast<IdentifierNode*>(*i)->name+" expected "+typeFullName((*i)->type)+" and received "+typeFullName((*v)->type)).c_str());
  }
};
void FunctionCallNode::print(){
  identifier->print();
  std::cout << "[" << values->size() << " params]";
  values->print();
}

void ArrayDeclarationNode::print(){
  std::cout << typeName(type) << " array: ";
  for(Node *node : *decls){
    std::cout << static_cast<IdentifierNode*>(node)->name << " (size:";
    static_cast<IdentifierNode*>(node)->value->print();
    std::cout << ")";
    if(node != decls->back())
      std::cout << ", ";
  }
}

IfThenElseNode::IfThenElseNode(Node *_if, BlockNode *then, BlockNode *_else) :
_if(_if), then(then), _else(_else) {
  if(_if->type != BOOL)
    yyerror(("semantic error: test operation expected boolean but received "+typeFullName(_if->type)).c_str());
}
void IfThenElseNode::print(){
  std::cout << "if:";
  _if->print();
  std::cout << std::endl;
  for(int i=0; i<BlockNode::tabs; i++)
    std::cout << "  ";
  std::cout << "then:" << std::endl;
  then->print();
  if(_else){
    std::cout << std::endl;
    for(int i=0; i<BlockNode::tabs; i++)
      std::cout << "  ";
    std::cout << "else:" << std::endl;
    _else->print();
  }
}

ForNode::ForNode(Node *init, Node *test, Node *iter, BlockNode *block) :
init(init), test(test), iter(iter), block(block) {
  if(test->type != BOOL)
    yyerror(("semantic error: test operation expected boolean but received "+typeFullName(test->type)).c_str());
}
void ForNode::print(){
  std::cout << "for: ";
  if(init) init->print();
  std::cout << ",";
  test->print();
  std::cout << ", ";
  if(iter) iter->print();
  std::cout << std::endl;
  for(int i=0; i<BlockNode::tabs; i++)
    std::cout << "  ";
  std::cout << "do:" << std::endl;
  block->print();
}
