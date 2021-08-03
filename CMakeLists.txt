cmake_minimum_required(VERSION 3.16)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/stm32-cmake/cmake/stm32_gcc.cmake)

project(stm32_test CXX C ASM)

set(STM32_CUBE_F1_PATH STM32CubeF1)
find_package(CMSIS COMPONENTS STM32F103C8 REQUIRED)

add_executable(stm32_test main.cpp)
target_link_libraries(stm32_test CMSIS::STM32::F103C8 STM32::NoSys)
stm32_print_size_of_target(stm32_test)
