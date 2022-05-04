//
// Created by ryanc on 2/7/2022.
//

#include <iostream>
#include "parse.h"
#include "expr.h"
#include "val.h"

using namespace std;

PTR(Expr) parse_expr(istream &in) {
    PTR(Expr) e;
    e = parse_comparg(in);

    skip_whitespace(in);

    char c = in.peek();
    if (c == '='){
        consume(in, '=');
        c = in.peek();
        if (c == '='){
            consume(in, '=');
            PTR(Expr) rhs = parse_expr(in);
            return NEW(EqualExpr)(e, rhs);
        } else {
            throw runtime_error("invalid '==' expression");
        }
    } else {
        return e;
    }

}

PTR(Expr) parse_comparg(istream &in) {
    PTR(Expr) e;
    e = parse_addend(in);

    skip_whitespace(in);

    char c = in.peek();
    if (c == '+') {
        consume(in, '+');
        PTR(Expr) rhs = parse_expr(in);
        return NEW(AddExpr)(e, rhs);
    } else {
        return e;
    }
}

PTR(Expr) parse_addend(std::istream &in){
    PTR(Expr) e;
    e = parse_multicand(in);

    skip_whitespace(in);

    char c = in.peek();
    if (c == '*'){
        consume(in, '*');
        PTR(Expr) rhs = parse_addend(in);
        return NEW(MultExpr)(e, rhs);
    } else {
        return e;
    }
}

PTR(Expr) parse_multicand(istream &in){
    PTR(Expr) e;
    e = parse_inner(in);

    skip_whitespace(in);
    while (in.peek() == '('){
        consume(in, '(');
        PTR(Expr) actual_arg = parse_expr(in);
        skip_whitespace(in);
        consume(in, ')');
        e = NEW(CallExpr)(e, actual_arg);
    }
    return e;
}

PTR(Expr) parse_inner(std::istream &in){
    skip_whitespace(in);

    char c = in.peek();
    if ((c == '-') || isdigit(c)){
        return parse_num(in);
    } else if (isCharacter(c)){
        return parse_var(in);
    } else if(c == '_'){
        consume(in, '_');
        c = in.peek();
        if (c == 'l'){
            return parse_let(in);
        } else if(c == 'i') {
            return parse_if(in);
        } else if (c == 't'){
            stringCheck( in, "true" );
            return NEW(BoolExpr)("_true");
        } else {
            consume(in, 'f');
            c = in.peek();
            if (c == 'u'){
                return parse_fun(in);
            } else {
                stringCheck(in, "alse");
                return NEW(BoolExpr)("_false");
            }
        }
    } else if (c == '('){
        consume(in, '(');
        PTR(Expr) e = parse_expr(in);
        skip_whitespace(in);
        c = in.get();
        if(c != ')') throw std::runtime_error("missing close parenthesis");
        return e;
    } else {
        consume(in, c);
        throw std::runtime_error("invalid input");
    }
}

PTR(Expr) parse_let(std::istream &in) {
    PTR(VarExpr) var;
    PTR(Expr) rhs;
    PTR(Expr) body;
    char c;

    stringCheck(in, "let");

    skip_whitespace(in);
    c = in.peek();
    if (!isCharacter(c)) throw std::runtime_error("invalid variable");
    var = CAST(VarExpr)(parse_var(in));

    stringCheck(in, "=");

    skip_whitespace(in);
    rhs = parse_expr(in);

    stringCheck(in, "_in");

    skip_whitespace(in);
    body = parse_expr(in);

    return NEW(LetExpr)(var, rhs, body);
}

PTR(Expr) parse_if(istream &in) {
    PTR(Expr) expr1;
    PTR(Expr) expr2;
    PTR(Expr) expr3;

    stringCheck(in, "if");

    skip_whitespace(in);
    expr1 = parse_expr(in);

    stringCheck(in, "_then");

    skip_whitespace(in);
    expr2 = parse_expr(in);

    stringCheck(in, "_else");

    skip_whitespace(in);
    expr3 = parse_expr(in);

    return NEW(IfExpr)(expr1, expr2, expr3);
}

PTR(Expr) parse_fun(std::istream &in){
    std::string formalArg;
    PTR(Expr) body;
    char c;

    stringCheck(in, "un");

    skip_whitespace(in);
    c = in.peek();
    if (c != '(') throw runtime_error("invalid function call");
    consume(in, '(');

    skip_whitespace(in);
    while (true){
        char c = (char)in.peek();
        if (isCharacter(c)){
            consume(in, c);
            formalArg += c;
        } else {
            if (c != ')') throw runtime_error("invalid function call");
            consume(in, ')');
            break;
        }
    }

    skip_whitespace(in);

    body = parse_expr(in);

    return NEW(FunExpr)(formalArg, body);
}

PTR(Expr) parse_var(std::istream &in) {
    std::string val;
    while (true){
        char c = (char)in.peek();
        if (isCharacter(c)){
            consume(in, c);
            val += c;
        } else
            break;
    }

    return NEW(VarExpr)(val);
}

PTR(Expr) parse_num(std::istream &in) {
    int n = 0;
    bool negative = false;

    if (in.peek() == '-'){
        negative = true;
        in.get();
    }

    while (true){
        int c = in.peek();
        if (isdigit(c)){
            consume(in, c);
            n = n*10 + (c - '0');
        } else
            break;
    }

    if (negative){
        n = -n;
    }

    return NEW(NumExpr)(n);
}

void consume(std::istream &in, int expect) {
    int c = in.get();
    if (c != expect) throw std::runtime_error("consume mismatch");
}

void skip_whitespace(std::istream &in){
    while (true){
        int c = in.peek();
        if (!isspace(c)) break;
        consume(in, c);
    }
}

bool isCharacter(char c) {
    if ((c >= 'A') && (c <= 'Z')) return true;
    if ((c >= 'a') && (c <= 'z')) return true;
    return false;
}

void stringCheck(std::istream &in, const string& st) {
    skip_whitespace(in);
    for (char s : st) {
        char c = (char) in.get();
        if (c != s) throw std::runtime_error("invalid expression");
    }
}
