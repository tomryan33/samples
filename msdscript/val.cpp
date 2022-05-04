//
// Created by Ryan Clayton on 2/16/22.
//

#include <stdexcept>
#include <utility>
#include "val.h"
#include "expr.h"
#include "env.h"

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

NumVal::NumVal(int val) {
    val_ = val;
}

//int NumVal::interp() {
//    return val_;
//}

bool NumVal::equals(PTR(Val) n) {
    PTR(NumVal) num = CAST(NumVal)(n);
    if (num == nullptr){
        return false;
    }
    return (val_ == num->val_);
}

PTR(Expr) NumVal::to_expr() {
    return NEW(NumExpr)(val_);
}

PTR(Val) NumVal::equal_to(PTR(Val) otherVal) {
    PTR(NumVal) other_num = CAST(NumVal)(otherVal);
    if (other_num == nullptr) throw std::runtime_error("equal of non-number");
    if (val_ == other_num->val_) return NEW(BoolVal)("_true");
    return NEW(BoolVal)("_false");
}

PTR(Val) NumVal::add_to(PTR(Val) otherVal) {
    PTR(NumVal) other_num = CAST(NumVal)(otherVal);
    if (other_num == nullptr) throw std::runtime_error("add of non-number");
    return NEW(NumVal)(val_ + other_num->val_);
}

PTR(Val) NumVal::multi_to(PTR(Val) otherVal) {
    PTR(NumVal) other_num = CAST(NumVal)(otherVal);
    if (other_num == nullptr) throw std::runtime_error("add of non-number");
    return NEW(NumVal)(val_ * other_num->val_);
}

PTR(Val) NumVal::call(PTR(Val) actualArg) {
    throw std::runtime_error("Cannot call number");
}

std::string NumVal::to_string() {
    return std::to_string(val_);
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

BoolVal::BoolVal(std::string val) {
    if (val != "_true" && val != "_false") throw std::runtime_error("Invalid boolean value.");
    val_ = std::move(val);
}

//std::string BoolVal::interp() {
//    return val_;
//}

bool BoolVal::equals(PTR(Val) n) {
    PTR(BoolVal) num = CAST(BoolVal)(n);
    if (num == nullptr){
        return false;
    }
    return (val_ == num->val_);
}

PTR(Expr) BoolVal::to_expr() {
    return NEW(BoolExpr)(val_);
}

PTR(Val) BoolVal::equal_to(PTR(Val) otherVal) {
    PTR(BoolVal) other_num = CAST(BoolVal)(otherVal);
    if (other_num == nullptr) return NEW(BoolVal)("_false");
    if (val_ == other_num->val_) return NEW(BoolVal)("_true");
    return NEW(BoolVal)("_false");
}

PTR(Val) BoolVal::add_to(PTR(Val) otherVal) {
    throw std::runtime_error("Cannot add a boolean.");
}

PTR(Val) BoolVal::multi_to(PTR(Val) otherVal) {
    throw std::runtime_error("Cannot multiply a boolean.");
}

PTR(Val) BoolVal::call(PTR(Val) actualArg) {
    throw std::runtime_error("Cannot call a boolean.");
}

std::string BoolVal::to_string() {
    return val_;
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

FunVal::FunVal(std::string formalArg, PTR(Expr) body, PTR(Env) env) {
    formalArg_ = formalArg;
    body_ = body;
    env_ = env;
}

bool FunVal::equals(PTR(Val) otherVal) {
    PTR(FunVal) fun = CAST(FunVal)(otherVal);
    if (fun == nullptr){
        return false;
    }
    return ( formalArg_ == fun->formalArg_ &&
             body_->equals(fun->body_) );
}

//auto FunVal::interp() {
//    return body_->subst(formalArg_, body_)->interp();
//}

PTR(Expr) FunVal::to_expr() {
    return NEW(FunExpr)(formalArg_, body_);
}

PTR(Val) FunVal::equal_to(PTR(Val) otherVal) {
    PTR(FunVal) other_fun = CAST(FunVal)(otherVal);
    if (other_fun == nullptr) throw std::runtime_error("equal of non-number");
    if (formalArg_ == other_fun->formalArg_ && body_->equals(other_fun->body_)) return NEW(BoolVal)("_true");
    return NEW(BoolVal)("_false");
}

PTR(Val) FunVal::add_to(PTR(Val) otherFun) {
    throw std::runtime_error("Unable to add two functions");
}

PTR(Val) FunVal::multi_to(PTR(Val) otherFun) {
    throw std::runtime_error("Unable to multiple two functions");
}

PTR(Val) FunVal::call(PTR(Val) actualArg) {
    return body_->interp(NEW(ExtendedEnv)(formalArg_, actualArg, env_));
}

std::string FunVal::to_string() {
    return "_fun (" + formalArg_ + ") " + body_->to_string();
}
