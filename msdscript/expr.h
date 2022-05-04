//
// Created by ryanc on 1/17/2022.
//

#ifndef MSDSCRIPT_EXPR_H
#define MSDSCRIPT_EXPR_H
#include <string>
#include "pointer.h"

class Val;
class Env;

typedef enum {
    prec_none,      // = 0
    prec_equal,     // = 1
    prec_add,       // = 2
    prec_mult       // = 3
} precedence_t;

CLASS(Expr) {
public:
    virtual ~Expr() { }

    virtual bool equals(PTR(Expr) rhs) = 0;
    virtual PTR(Val) interp(PTR(Env) env) = 0;
    //virtual PTR(Expr) subst(std::string var, PTR(Expr) e) = 0;
    virtual void print(std::ostream& stream) = 0;
    virtual void pretty_print(std::ostream& stream);
    virtual void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]);
    std::string to_string();
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class NumExpr: public Expr{
public:
    PTR(Val) rep_;

    // Constructors
    explicit NumExpr(int val);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class BoolExpr: public Expr{
public:
    PTR(Val) rep_;

    // Constructors
    explicit BoolExpr(std::string val);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;

};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class EqualExpr: public Expr{
public:
    PTR(Expr) lhs_;
    PTR(Expr) rhs_;

    //Constructors
    EqualExpr(PTR(Expr) lhs, PTR(Expr) rhs);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    void pretty_print(std::ostream& stream) override;
    void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;

};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class AddExpr: public Expr{
public:
    PTR(Expr) lhs_;
    PTR(Expr) rhs_;

    // Constructors
    AddExpr(PTR(Expr) lhs, PTR(Expr) rhs);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    void pretty_print(std::ostream& stream) override;
    void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class MultExpr: public Expr{
public:
    PTR(Expr) lhs_;
    PTR(Expr) rhs_;

    // Constructors
    MultExpr(PTR(Expr) lhs, PTR(Expr) rhs);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    void pretty_print(std::ostream& stream) override;
    void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class CallExpr: public Expr{
public:
    PTR(Expr) toBeCalled_;
    PTR(Expr) actualArg_;

    // Constructors
    CallExpr(PTR(Expr) toBeCalled, PTR(Expr) actualArg);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    //void pretty_print(std::ostream& stream) override;
    //void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;

};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class VarExpr: public Expr{
public:
    std::string val_;

    // Constructors
    explicit VarExpr(std::string val);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class LetExpr: public Expr{
public:
    PTR(VarExpr) var_;
    PTR(Expr) rhs_;
    PTR(Expr) body_;

    // Constructors
    LetExpr(PTR(VarExpr) var, PTR(Expr) rhs, PTR(Expr) body);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    void pretty_print(std::ostream& stream) override;
    void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class IfExpr: public Expr{
public:
    PTR(Expr) if_;
    PTR(Expr) then_;
    PTR(Expr) else_;

    // Constructors
    IfExpr(PTR(Expr) expr1, PTR(Expr) expr2, PTR(Expr) expr3);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    void pretty_print(std::ostream& stream) override;
    void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

class FunExpr: public Expr{
public:
    std::string formalArg_;
    PTR(Expr) body_;

    // Constructors
    FunExpr(std::string formalArg, PTR(Expr) body);

    // Methods
    bool equals(PTR(Expr) rhs) override;
    PTR(Val) interp(PTR(Env) env) override;
    //PTR(Expr) subst(std::string var, PTR(Expr) e) override;
    void print(std::ostream& stream) override;
    //void pretty_print(std::ostream& stream) override;
    //void pretty_print_at(std::ostream& stream, precedence_t pc, bool prec_let, int pos[]) override;
};

// ===== * ===== * ===== * ===== * ===== * ===== * ===== * ===== //

void add_spaces(std::ostream &stream, int pos);

#endif //MSDSCRIPT_EXPR_H
