//
// Created by ryanc on 4/16/2022.
//

#ifndef MSDSCRIPT_MSDSCRIPT_H
#define MSDSCRIPT_MSDSCRIPT_H

#include <string>
#include <sstream>
#include "expr.h"
#include "parse.h"
#include "val.h"
#include "env.h"

std::string MSDInterp(const std::string& str){
    std::istringstream is(str);

    PTR(Expr) e = parse_expr(is);

    return e->interp(EmptyEnv::empty_)->to_string();
}

#endif //MSDSCRIPT_MSDSCRIPT_H
