//
// Created by ryanc on 1/11/2022.
//

#ifndef MSDSCRIPT_CMDLINE_H
#define MSDSCRIPT_CMDLINE_H

#include "pointer.h"

class Expr;

void use_arguments(int argc, const char * argv[]);
PTR(Expr) getNextLine();

#endif //MSDSCRIPT_CMDLINE_H
