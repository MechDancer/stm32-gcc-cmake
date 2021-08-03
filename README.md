# stm32-gcc-cmake

ubuntu 上使用 gcc+cmake+gcc_arm_none_eabi 编译 STM32 项目的示例项目。

可以使用 LL HAL。

## 说明

子模块 `stm32-cmake` 提供 cmake 模板，在应用项目的 CMakeLists.txt 文件中引用它。

示例：

```CMakeLists.txt
cmake_minimum_required(VERSION 3.16) # 判定 cmake 版本符合要求，stm32-cmake 模块本身要求至少 3.16
set(CMAKE_TOOLCHAIN_FILE             # 引用 stm32-cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/stm32-cmake/cmake/stm32_gcc.cmake)

project(stm32_test CXX C ASM)        # 设定项目名字和支持语言
set(CMAKE_CXX_STANDARD 20)           # 设定语法级别
set(CMAKE_CXX_STANDARD_REQUIRED ON)  #
set(CMAKE_INCLUDE_CURRENT_DIR TRUE)  # 引用根目录

set(STM32_CUBE_F1_PATH STM32CubeF1)                          # 查找 STMCubeF1 库
find_package(CMSIS COMPONENTS STM32F103C8 REQUIRED)          # 引用 CMSIS
find_package(HAL COMPONENTS STM32F1 LL_RCC LL_GPIO REQUIRED) # 引用 HAL

add_executable(stm32_test main.cpp)    # 一个构建目标
target_link_libraries(stm32_test       # 链接库
    HAL::STM32::F1::LL_RCC             #
    HAL::STM32::F1::LL_GPIO            #
    CMSIS::STM32::F103C8               #
    STM32::NoSys)                      #
stm32_print_size_of_target(stm32_test) #
```
