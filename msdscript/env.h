//
// Created by ryanc on 3/29/2022.
//

#ifndef MSDSCRIPT_ENV_H
#define MSDSCRIPT_ENV_H

#include "pointer.h"
#include <string>

class Val;

CLASS(Env) {
public:
    static PTR(Env) empty_;
    virtual PTR(Val) lookup(std::string find_name) = 0;
};

class EmptyEnv: public Env {
public:
    EmptyEnv();
    PTR(Val) lookup(std::string find_name) override;
};

class ExtendedEnv: public Env {
private:
    std::string name_;
    PTR(Val) val_;
    PTR(Env) rest_;

public:
    ExtendedEnv(std::string name, PTR(Val) val, PTR(Env) rest);
    PTR(Val) lookup(std::string find_name) override;
};


#endif //MSDSCRIPT_ENV_H
