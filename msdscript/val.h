//
// Created by Ryan Clayton on 2/16/22.
//

#ifndef MSDSCRIPT_VAL_H
#define MSDSCRIPT_VAL_H

#include <string>
#include "pointer.h"

class Expr;
class Env;

CLASS(Val){
public:
    virtual ~Val() { }

    virtual bool equals(PTR(Val) e) = 0;
    virtual PTR(Expr) to_expr() = 0;
    virtual PTR(Val)  equal_to(PTR(Val) otherVal) = 0;
    virtual PTR(Val)  add_to(PTR(Val) otherVal) = 0;
    virtual PTR(Val)  multi_to(PTR(Val) otherVal) = 0;
    virtual PTR(Val) call(PTR(Val)  actualArg) = 0;
    virtual std::string to_string() = 0;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class NumVal: public Val{
public:
    int val_;

    // Constructors
    explicit NumVal(int val);

    // Methods
    bool equals(PTR(Val) n) override;
    //int interp();
    PTR(Expr) to_expr() override;
    PTR(Val)  equal_to(PTR(Val) otherVal) override;
    PTR(Val)  add_to(PTR(Val) otherVal) override;
    PTR(Val)  multi_to(PTR(Val) otherVal) override;
    PTR(Val) call(PTR(Val) actualArg) override;
    std::string to_string() override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class BoolVal: public Val{
public:
    std::string val_;

    // Constructors
    explicit BoolVal(std::string val);

    // Methods
    bool equals(PTR(Val) b) override;
    //std::string interp();
    PTR(Expr) to_expr() override;
    PTR(Val)  equal_to(PTR(Val) otherVal) override;
    PTR(Val)  add_to(PTR(Val) otherVal) override;
    PTR(Val)  multi_to(PTR(Val) otherVal) override;
    PTR(Val) call(PTR(Val) actualArg) override;
    std::string to_string() override;

};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class FunVal: public Val{
public:
    std::string formalArg_;
    PTR(Expr) body_;
    PTR(Env) env_;

    // Constructors
    FunVal(std::string formalArg, PTR(Expr) body, PTR(Env) env);

    // Methods
    bool equals(PTR(Val) b) override;
    //auto interp();
    PTR(Expr) to_expr() override;
    PTR(Val)  equal_to(PTR(Val) otherVal) override;
    PTR(Val)  add_to(PTR(Val) otherFun) override;
    PTR(Val)  multi_to(PTR(Val) otherVal) override;
    PTR(Val) call(PTR(Val) actualArg) override;
    std::string to_string() override;


};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //


#endif //MSDSCRIPT_VAL_H
