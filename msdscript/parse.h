//
// Created by ryanc on 2/7/2022.
//

#ifndef MSDSCRIPT_PARSE_H
#define MSDSCRIPT_PARSE_H

#include <istream>
#include "pointer.h"

class Expr;

PTR(Expr) parse_expr(std::istream &in);
PTR(Expr) parse_comparg(std::istream &in);
PTR(Expr) parse_num(std::istream &in);
PTR(Expr) parse_addend(std::istream &in);
PTR(Expr) parse_multicand(std::istream &in);
PTR(Expr) parse_inner(std::istream &in);
PTR(Expr) parse_let(std::istream &in);
PTR(Expr) parse_if(std::istream &in);
PTR(Expr) parse_var(std::istream &in);
PTR(Expr) parse_fun(std::istream &in);
void consume(std::istream &istream, int c);
void skip_whitespace(std::istream &in);
bool isCharacter(char c);
void stringCheck(std::istream &in, const std::string& st);

#endif //MSDSCRIPT_PARSE_H
