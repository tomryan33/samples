//
// Created by ryanc on 3/29/2022.
//

#include <stdexcept>
#include <utility>
#include "env.h"

PTR(Env) Env::empty_ = NEW(EmptyEnv)();

EmptyEnv::EmptyEnv() = default;

PTR(Val) EmptyEnv::lookup(std::string find_name) {
    throw std::runtime_error("Error: " + find_name);
}

ExtendedEnv::ExtendedEnv(std::string name, PTR(Val) val, PTR(Env) rest){
    name_ = name;
    val_ = val;
    rest_ = rest;
}

PTR(Val) ExtendedEnv::lookup(std::string find_name) {
    if (find_name == name_){
        return val_;
    } else {
        return rest_->lookup(find_name);
    }
}
