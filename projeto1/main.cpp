#include <list>
#include <iostream>
#include "ast.h"

extern int yyparse();
extern BlockNode lines;

int main(){
  yyparse();
  lines.print();
  std::cout << std::endl;
  return 0;
}
