#include <list>
#include <iostream>
#include "ast.h"

extern int yyparse();
extern std::list<Node*> lines;

int main(){
  yyparse();
  for(Node *line : lines){
    //std::cout << "Line[";
    line->print();
    //std::cout << "]";
    std::cout << std::endl;
  }
  return 0;
}
