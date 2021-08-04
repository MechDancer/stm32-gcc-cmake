# stm32-gcc-cmake

ubuntu 上使用 gcc+cmake+gcc_arm_none_eabi 编译 STM32 项目的示例项目。

可以使用 LL HAL。

## 使用说明

### 仿照此项目建立 stm32 项目的步骤

1. 新建并进入项目路径：```mkdir <项目名称> && cd <项目名称>```
2. 创建 git 仓库：```git init```
3. 添加子模块：

   > **注意**：用目标芯片系列替换 `STM32CubeF1`

   ```bash
   git submodule add https://github.com/ObKo/stm32-cmake.git
   git submodule add https://github.com/STMicroelectronics/STM32CubeF1.git
   ```

4. 拷贝 `.clang-format`、`.gitignore`、`CmakeLists.txt` 和 `Makefile`
5. 根据需要修改 `CMakeLists.txt`
6. 写 `README.md`
7. 添加源文件

### 构建此类项目的步骤

## 文件说明

### 目录结构

本节介绍示例项目目录结构。

```raw
.                  # 根目录
├── .clang-format  # 配合编辑器或集成开发环境自动格式化 c/c++ 源文件
├── .git           # 表示为项目目录创建了一个 git 仓库
│   └── ...        #
├── .gitignore     # 指定 git 仓库的排除路径，主要是 `build/`
├── .gitmodules    # 指定 git 子模块
├── CMakeLists.txt # 指定项目编译方式
├── app            # 目标入口点放在这个目录下
│   └── main.cpp   #
├── Makefile       # 简化编译指令
├── README.md      # 项目说明文件
├── STM32CubeF1    # 子模块。提供 cmake 模板，供 CMakeLists.txt 使用
│   └── ...        #
├── build          # 构建目录，从 git 排除
│   └── ...        #
└── stm32-cmake    # 子模块（[产品页](https://www.st.com/zh/embedded-software/stm32cubef1.html)）。STM32F1 产品系列的软件包，在 CMakeLists.txt 中引用
    └── ...        #
```

### 配置文件示例

本节介绍示例项目配置文件。按文件名字典顺序排序。

- .clang-format

  为编辑器或集成开发环境提供 c/c++ 源文件格式化规则。此项目包含在项目中有助于项目编码风格的一致性。

  本文件通过 clion 生成。详细配置项参见 [.clang-format 文档](https://clang.llvm.org/docs/ClangFormat.html)。

  示例：略。

- .gitignore

  示例：

  ```.gitignore
  build/          # cmake 常用的命令行构建路径
  cmake-build-**/ # clion 默认的 cmake 构建路径

  .*/             # 常见 ide/editor 创建的配置文件路径，排除这类路径使项目对开发工具中立
  ```

- .gitmodules

  用于项目递归克隆时自动克隆子模块。

  通过 `git submodules add <子模块项目路径>` 指令自动创建和修改，不应该手工修改。

  示例：

  ```.gitmodules
  [submodule "stm32-cmake"]
      path = stm32-cmake
      url = https://github.com/ObKo/stm32-cmake.git
  [submodule "STM32CubeF1"]
      path = STM32CubeF1
      url = https://github.com/STMicroelectronics/STM32CubeF1.git
  ```

- CMakeLists.txt

  cmake 项目配置。

  示例和说明：

  ```CMakeLists.txt
  cmake_minimum_required(VERSION 3.16) # 判定 cmake 版本符合要求，stm32-cmake 模块本身要求至少 3.16
  set(CMAKE_TOOLCHAIN_FILE             # 引用 stm32-cmake
      ${CMAKE_CURRENT_SOURCE_DIR}/stm32-cmake/cmake/stm32_gcc.cmake)

  project(stm32_test CXX C ASM)        # 设定项目名字和支持语言
  set(CMAKE_CXX_STANDARD 20)           # 设定语法级别
  set(CMAKE_CXX_STANDARD_REQUIRED ON)  #
  set(CMAKE_INCLUDE_CURRENT_DIR TRUE)  # 引用根目录

  set(STM32_CUBE_F1_PATH STM32CubeF1)                          # 查找 STMCubeF1 库
  find_package(CMSIS COMPONENTS STM32F103C8 REQUIRED)          # 逐设备引用 CMSIS
  find_package(HAL COMPONENTS STM32F1 LL_RCC LL_GPIO REQUIRED) # 逐模块引用 HAL

  add_library(stm32_test           # 构建一个静态库。静态库只需要构建一次，可以在多个目标之间复用
      src/library.h                # 库的头文件，头文件不需要编译，但写在这里 VSCode + CMake 插件才会为其提供正确的高亮和跳转
      src/library.c                # 库的源文件，支持 c
      src/library.cpp)             # 库的源文件，支持 c++
  target_link_libraries(stm32_test # 将 CMSIS、LL、HAL 链接到库
      HAL::STM32::F1::LL_RCC       #
      HAL::STM32::F1::LL_GPIO      #
      CMSIS::STM32::F103C8         # 对于同时适用多种芯片的库，不用在这里链接芯片相关库
      STM32::NoSys)                #

  add_executable(stm32_test_app app/main.cpp)      # 一个构建目标
  target_link_libraries(stm32_test_app stm32_test) # 链接库
  stm32_print_size_of_target(stm32_test_app)       # 打印目标文件容量
  ```

- Makefile

  简化使用 cmake 构建项目的步骤。

  > **注意**：不要从 markdown 文件中拷贝 Makefile。Makefile 文件要求脚本指令前使用 `tab`，markdown 中为规范格式已替换为空格。

  示例和说明：

  ```Makefile
  .PHONY : build # 按 release 构建
  build:
      mkdir -p build/release
      cd build/release \
      && cmake -DCMAKE_BUILD_TYPE=Release \
         ../.. \
      && make -j2

  .PHONY : build-debug # 按 debug 构建
  debug:
      mkdir -p build/debug
      cd build/debug \
      && cmake -DCMAKE_BUILD_TYPE=Debug \
         ../.. \
      && make -j2

  .PHONY : clean # 删除构建目录
  clean:
      rm -rf build
  ```
