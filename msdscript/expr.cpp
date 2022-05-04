//
// Created by ryanc on 1/17/2022.
//

#include "expr.h"
#include <iostream>
#include <sstream>
#include <utility>
#include "val.h"
#include "env.h"

using namespace std;

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

void Expr::pretty_print(ostream &stream) {
    print(stream);
}

void Expr::pretty_print_at(ostream &stream, precedence_t pc, bool prec_let, int pos[]) {
    print(stream);
}

std::string Expr::to_string() {
    ostringstream stream;
    print(stream);
    return stream.str();
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

NumExpr::NumExpr(int val) {
    rep_ = NEW(NumVal)(val);
}

bool NumExpr::equals(PTR(Expr) rhs) {
    PTR(NumExpr) num = CAST(NumExpr)(rhs);
    if (num == nullptr){
        return false;
    }
    return (rep_->equals(num->rep_));
}

PTR(Val) NumExpr::interp(PTR(Env) env) {
    return rep_;
}

/*PTR(Expr) NumExpr::subst(std::string var, PTR(Expr) e) {
    return rep_->to_expr();
}*/

void NumExpr::print(ostream &stream) {
    stream << rep_->to_string();
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

BoolExpr::BoolExpr(std::string val) {
    rep_ = NEW(BoolVal)(val);
}

bool BoolExpr::equals(PTR(Expr) rhs) {
    PTR(BoolExpr) val = CAST(BoolExpr)(rhs);
    if (val == nullptr){
        return false;
    }
    return (rep_->equals(val->rep_));
}

PTR(Val) BoolExpr::interp(PTR(Env) env) {
    return rep_;
}

/*PTR(Expr) BoolExpr::subst(std::string var, PTR(Expr) e) {
    return rep_->to_expr();
}*/

void BoolExpr::print(ostream &stream) {
    stream << rep_->to_string();
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

EqualExpr::EqualExpr(PTR(Expr) lhs, PTR(Expr) rhs){
    lhs_ = lhs;
    rhs_ = rhs;
}

bool EqualExpr::equals(PTR(Expr) rhs) {
    PTR(EqualExpr) equal = CAST(EqualExpr)(rhs);
    if (equal == nullptr){
        return false;
    }
    return ((lhs_->equals(equal->lhs_)) &&
            (rhs_->equals(equal->rhs_)));
}

PTR(Val) EqualExpr::interp(PTR(Env) env) {
    return lhs_->interp(env)->equal_to(rhs_->interp(env));
}

/*PTR(Expr) EqualExpr::subst(std::string var, PTR(Expr) e) {
    return NEW(EqualExpr)(lhs_->subst(var, e), rhs_->subst(var, e) );
}*/

void EqualExpr::print(ostream &stream) {
    stream << "(";
    lhs_->print(stream);
    stream << "==";
    rhs_->print(stream);
    stream << ")";
}

void EqualExpr::pretty_print(ostream &stream) {
    int pos[2] = {0, 0};
    pretty_print_at(stream, prec_none, false, pos);
}

void EqualExpr::pretty_print_at(ostream &stream, precedence_t pc, bool prec_let, int pos[]) {
    if (pc >= prec_equal ){
        stream << "(";
    }
    lhs_->pretty_print_at(stream, prec_equal, true, pos);
    stream << " == ";
    rhs_->pretty_print_at(stream, prec_none, prec_let, pos);
    if (pc >= prec_equal){
        stream << ")";
    }
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

AddExpr::AddExpr(PTR(Expr) lhs, PTR(Expr) rhs){
    lhs_ = lhs;
    rhs_ = rhs;
}

bool AddExpr::equals(PTR(Expr) rhs) {
    PTR(AddExpr) add = CAST(AddExpr)(rhs);
    if (add == nullptr){
        return false;
    }
    return ((lhs_->equals(add->lhs_)) &&
            (rhs_->equals(add->rhs_)));
}

PTR(Val) AddExpr::interp(PTR(Env) env) {
    return lhs_->interp(env)->add_to(rhs_->interp(env));
}

/*PTR(Expr) AddExpr::subst(std::string var, PTR(Expr) e) {
    return NEW(AddExpr)(lhs_->subst(var, e), rhs_->subst(var, e) );
}*/

void AddExpr::print(ostream &stream) {
    stream << "(";
    lhs_->print(stream);
    stream << "+";
    rhs_->print(stream);
    stream << ")";
}

void AddExpr::pretty_print(ostream &stream) {
    int pos[2] = {0, 0};
    pretty_print_at(stream, prec_equal, false, pos);
}

void AddExpr::pretty_print_at(ostream &stream, precedence_t pc, bool prec_let, int pos[]) {
    if (pc >= prec_add ){
        stream << "(";
    }
    lhs_->pretty_print_at(stream, prec_add, true, pos);
    stream << " + ";
    rhs_->pretty_print_at(stream, prec_equal, prec_let, pos);
    if (pc >= prec_add){
        stream << ")";
    }
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

MultExpr::MultExpr(PTR(Expr) lhs, PTR(Expr) rhs){
    lhs_ = lhs;
    rhs_ = rhs;
}

bool MultExpr::equals(PTR(Expr) rhs) {
    PTR(MultExpr) mult = CAST(MultExpr)(rhs);
    if (mult == nullptr){
        return false;
    }
    return ((lhs_->equals(mult->lhs_)) &&
            (rhs_->equals(mult->rhs_)));
}

PTR(Val) MultExpr::interp(PTR(Env) env) {
    return lhs_->interp(env)->multi_to(rhs_->interp(env));
}

/*PTR(Expr) MultExpr::subst(std::string var, PTR(Expr) e) {
    return NEW(MultExpr)(lhs_->subst(var, e), rhs_->subst(var, e) );
}*/

void MultExpr::print(ostream &stream) {
    stream << "(";
    lhs_->print(stream);
    stream << "*";
    rhs_->print(stream);
    stream << ")";
}

void MultExpr::pretty_print(ostream &stream) {
    int pos[2] = {0, 0};
    pretty_print_at(stream, prec_add, false, pos);
}

void MultExpr::pretty_print_at(ostream &stream, precedence_t pc, bool prec_let, int pos[]) {
    if ( pc >= prec_mult ){
        stream << "(";
    }
    lhs_->pretty_print_at(stream, prec_mult, prec_let, pos);
    stream << " * ";
    rhs_->pretty_print_at(stream, prec_add, prec_let, pos);
    if ( pc >= prec_mult ){
        stream << ")";
    }
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

CallExpr::CallExpr(PTR(Expr) toBeCalled, PTR(Expr) actualArg) {
    toBeCalled_ = toBeCalled;
    actualArg_ = actualArg;
}

bool CallExpr::equals(PTR(Expr) rhs) {
    PTR(CallExpr) call = CAST(CallExpr)(rhs);
    if (call == nullptr){
        return false;
    }
    return ( toBeCalled_->equals( call->toBeCalled_ ) &&
             actualArg_->equals( call->actualArg_ ) );
}

PTR(Val) CallExpr::interp(PTR(Env) env) {
    return toBeCalled_->interp(env)->call(actualArg_->interp(env));
}

/*PTR(Expr) CallExpr::subst(std::string var, PTR(Expr) e) {
    return NEW(CallExpr)( toBeCalled_->subst(var, e), actualArg_->subst(var, e) );
}*/

void CallExpr::print(std::ostream &stream) {
    toBeCalled_->print(stream);
    stream << "(";
    actualArg_->print(stream);
    stream << ")";
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

VarExpr::VarExpr(std::string val) {
    val_ = move(val);
}

bool VarExpr::equals(PTR(Expr) rhs) {
    PTR(VarExpr) var = CAST(VarExpr)(rhs);
    if (var == nullptr){
        return false;
    }
    return (val_ == var->val_);
}

PTR(Val) VarExpr::interp(PTR(Env) env) {
    return env->lookup(val_);
}

/*PTR(Expr) VarExpr::subst(std::string var, PTR(Expr) e) {
    if( equals( NEW(VarExpr)(var) ) ){
        return e;
    }
    return NEW(VarExpr)(val_);
}*/

void VarExpr::print(ostream &stream) {
    stream << val_;
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

LetExpr::LetExpr(PTR(VarExpr) var, PTR(Expr) rhs, PTR(Expr) body){
    var_ = var;
    rhs_ = rhs;
    body_ = body;
}

bool LetExpr::equals(PTR(Expr) rhs) {
    PTR(LetExpr) let = CAST(LetExpr)(rhs);
    if (let == nullptr){
        return false;
    }
    return (( var_->equals(let->var_ ) ) &&
            ( rhs_->equals(let->rhs_ ) ) &&
            ( body_->equals(let->body_ ) ));
}

PTR(Val) LetExpr::interp(PTR(Env) env) {
    PTR(Val) rhs_val = rhs_->interp(env);
    PTR(Env) new_env = NEW(ExtendedEnv)(var_->val_, rhs_val, env);
    return body_->interp(new_env);
}

/*PTR(Expr) LetExpr::subst(std::string var, PTR(Expr) e) {
    if (var == var_->val_){
        return NEW(LetExpr)(var_, rhs_->subst(var, e), body_);
    }
    return NEW(LetExpr)(var_, rhs_->subst(var, e), body_->subst(var, e) );
}*/


void LetExpr::print(ostream &stream) {
    stream << "(_let ";
    var_->print(stream);
    stream << "=";
    rhs_->print(stream);
    stream << " _in ";
    body_->print(stream);
    stream << ")";
}

void LetExpr::pretty_print(ostream &stream) {
    int pos[2] = {0, 0};
    pretty_print_at(stream, prec_none, false, pos);
}

void LetExpr::pretty_print_at(ostream &stream, precedence_t pc, bool prec_let, int pos[]) {
    if ( prec_let ){
        stream << "(";
    }

    pos[0] = (int)stream.tellp() - pos[1];
    stream << "_let ";
    var_->pretty_print_at(stream, prec_none, prec_let, pos);
    stream << " = ";
    rhs_->pretty_print_at(stream, prec_none, prec_let, pos);
    stream << "\n";
    pos[1] = (int)stream.tellp();
    add_spaces(stream, pos[0] );
    stream << "_in  ";
    body_->pretty_print_at(stream, prec_none, true, pos);

    if ( prec_let ){
        stream << ")";
    }
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

IfExpr::IfExpr(PTR(Expr) expr1, PTR(Expr) expr2, PTR(Expr) expr3) {
    if_ = expr1;
    then_ = expr2;
    else_ = expr3;
}


bool IfExpr::equals(PTR(Expr) rhs){
    PTR(IfExpr) ifExp = CAST(IfExpr)(rhs);
    if (ifExp == nullptr){
        return false;
    }
    return (( if_->equals(ifExp->if_ ) ) &&
            ( then_->equals(ifExp->then_ ) ) &&
            ( else_->equals(ifExp->else_ ) ));
}

PTR(Val) IfExpr::interp(PTR(Env) env){
    if (if_->interp(env)->to_string() == "_true"){
        return then_->interp(env);
    }
    return else_->interp(env);
}

/*PTR(Expr) IfExpr::subst(std::string var, PTR(Expr) e){
    return NEW(IfExpr)( if_->subst( var, e ), then_->subst( var, e ), else_->subst( var, e ) );
}*/

void IfExpr::print(std::ostream& stream){
    stream << "(_if ";
    if_->print(stream);
    stream << " _then ";
    then_->print(stream);
    stream << " _else ";
    else_->print(stream);
    stream << ")";
}

void IfExpr::pretty_print(std::ostream& stream){
    int pos[2] = {0, 0};
    pretty_print_at(stream, prec_none, false, pos);
}

void IfExpr::pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_if, int pos[]){
    if ( prec_if ){
        stream << "(";
    }
    pos[0] = (int)stream.tellp() - pos[1];
    stream << "_if ";
    if_->pretty_print_at(stream, prec_none, prec_if, pos);

    stream << "\n";
    pos[1] = (int)stream.tellp();
    add_spaces(stream, pos[0] );
    pos[0] = (int)stream.tellp() - pos[1];
    stream << "_then ";
    then_->pretty_print_at(stream, prec_none, prec_if, pos);

    stream << "\n";
    pos[1] = (int)stream.tellp();
    add_spaces(stream, pos[0] );
    stream << "_else ";
    else_->pretty_print_at(stream, prec_none, true, pos);

    if ( prec_if ){
        stream << ")";
    }
}

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

FunExpr::FunExpr(std::string formalArg, PTR(Expr) body) {
    formalArg_ = formalArg;
    body_ = body;
}

bool FunExpr::equals(PTR(Expr) rhs) {
    PTR(FunExpr) fun = CAST(FunExpr)(rhs);
    if (fun == nullptr){
        return false;
    }
    return ( formalArg_ == fun->formalArg_ &&
             body_->equals( fun->body_ ) );
}

PTR(Val) FunExpr::interp(PTR(Env) env) {
    return NEW(FunVal)(formalArg_, body_, env);
}

/*PTR(Expr) FunExpr::subst(std::string var, PTR(Expr) e) {
    return NEW(FunExpr)(formalArg_, body_->subst(var, e) );
}*/

void FunExpr::print(ostream &stream) {
    stream << "_fun (";
    stream << formalArg_;
    stream << ") ";
    body_->print(stream);
}



// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //
// Helper Functions

void add_spaces(ostream &stream, int pos) {
    for (int i = 0; i < pos; ++i) {
        stream << " ";
    }
}
