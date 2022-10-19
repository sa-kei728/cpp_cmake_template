cmake_minimum_required(VERSION 3.0)

project(main CXX)

set(MAINAPP "main")

add_executable(${MAINAPP}.elf src/main.cpp)
target_compile_options(${MAINAPP}.elf  PUBLIC $<$<CXX_COMPILER_ID:GNU>: -Wall -Wextra -Winit-self -Wno-missing-field-initializers>)
target_include_directories(${MAINAPP}.elf PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_features(${MAINAPP}.elf PUBLIC cxx_std_17)

include(FetchContent)
FetchContent_Declare(
  googletest
  # Specify the commit you depend on and update it regularly.
  URL https://github.com/google/googletest/archive/e2239ee6043f73722e7aa812a459f54a28552929.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# Now simply link against gtest or gtest_main as needed. Eg
add_executable(${MAINAPP}_test.elf src/main.cpp test/main_test.cpp)
target_link_libraries(${MAINAPP}_test.elf gtest_main)
target_include_directories(${MAINAPP}_test.elf PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_definitions(${MAINAPP}_test.elf PUBLIC GTEST)
target_compile_features(${MAINAPP}_test.elf PUBLIC cxx_std_17)
add_test(NAME test COMMAND ${MAINAPP}_test.elf)

enable_testing()
