#include "main.h"

#include <iostream>

void main_hello() { std::cout << "main hello!" << std::endl; }

#ifndef GTEST
int main([[maybe_unused]] int argc, [[maybe_unused]] char* argv[]) {
    hello();
    return 0;
}
#endif
