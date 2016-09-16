#include <list>
#include "ast.h"

extern int yyparse();
extern std::list<Node*> lines;

int main(){
  yyparse();
  for(Node *line : lines){
    line->print();
  }
  return 0;
}
