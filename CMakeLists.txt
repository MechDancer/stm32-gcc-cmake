cmake_minimum_required(VERSION 3.16)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/stm32-cmake/cmake/stm32_gcc.cmake)

project(stm32_test CXX C ASM)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR TRUE)

set(STM32_CUBE_F1_PATH STM32CubeF1)
find_package(CMSIS COMPONENTS STM32F103C8 REQUIRED)
find_package(HAL COMPONENTS STM32F1 LL_RCC LL_GPIO REQUIRED)

add_library(stm32_test
    src/library.h
    src/library.c
    src/library.cpp)
target_link_libraries(stm32_test
    HAL::STM32::F1::LL_RCC
    HAL::STM32::F1::LL_GPIO
    CMSIS::STM32::F103C8
    STM32::NoSys)

add_executable(stm32_test_app app/main.cpp)
target_link_libraries(stm32_test_app stm32_test)
stm32_print_size_of_target(stm32_test_app)
