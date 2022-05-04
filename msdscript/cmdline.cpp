//
// Created by ryanc on 1/11/2022.
//
#include <iostream>
#include "cmdline.h"
#define CATCH_CONFIG_RUNNER
#include "catch.h"
#include "expr.h"
#include "parse.h"
#include "val.h"
#include "env.h"


void use_arguments(int argc, const char * argv[]){
    if (argc <= 1){
        std::cout << "Missing argument\n";
        exit(0);
    }

    bool testCheck = false;
    for (int i = 1; i < argc; i++) {
        std::string command = argv[i];
        if (command == "--help") {
            std::cout << "** HELP - COMMON COMMANDS **\n";
            std::cout << "  '--help': show help menu'\n";
            std::cout << "  '--test': run catch tests'\n";
            exit(0);
        } else if (command == "--test") {
            if (testCheck){
                std::cerr << "Test have already been passed.\n";
                exit(1);
            }
            testCheck = true;

            // run tests
            if(Catch::Session().run(1, argv) != 0){
                exit(1);
            }

        } else if (command == "--interp"){
            while(true){
                PTR(Expr) e = getNextLine();

                std::cout << e->interp(EmptyEnv::empty_)->to_string();
                std::cout << "\n";

                skip_whitespace(std::cin);
                if (std::cin.eof()) break;
            }
        } else if (command == "--print"){
            while(true){
                PTR(Expr) e = getNextLine();

                e->print(std::cout);
                std::cout << "\n";

                skip_whitespace(std::cin);
                if (std::cin.eof()) break;
            }

        } else if (command == "--pretty-print"){
            while(true){
                PTR(Expr) e = getNextLine();

                e->pretty_print(std::cout);
                std::cout << "\n";

                skip_whitespace(std::cin);
                if (std::cin.eof()) break;
            }

        } else {
            std::cerr << "Invalid argument.\n";
            exit(1);
        }
    }

}

PTR(Expr) getNextLine(){
    return parse_expr(std::cin);
    std::string line;
    getline(std::cin, line);
    std::istringstream str(line);
    return parse_expr(str);
}