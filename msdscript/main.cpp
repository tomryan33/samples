#include <iostream>
#include "cmdline.h"

int main(int argc, const char * argv[]) {
    try {
        use_arguments(argc, argv);
        return 0;
    } catch (std::runtime_error exn){
        std::cerr << exn.what() << "\n";
        return 1;
    }
}