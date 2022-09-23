# CMakeList.txt: MyRISC-VCore_Model_CMake 的 CMake 项目，在此处包括源代码并定义
# 项目特定的逻辑。
#
cmake_minimum_required (VERSION 3.12)

project ("MyRISC-VCore_Model")

include_directories(./src/top_header ./src/tools)
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
set(CMAKE_BUILD_TYPE "Debug")
#set(CMAKE_BUILD_TYPE "Release")

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("/std:c++17" _cpp_17_flag_supported)

if(_cpp_17_flag_supported)
	add_compile_options("/std:c++17")
endif()

set(CMAKE_CXX_STACK_SIZE "10485760")

# 将源代码添加到此项目的可执行文件。
file(GLOB_RECURSE src_files CONFIGURE_DEPENDS "./src/*.cpp" "./src/*.h")
add_executable(sim ${src_files})

target_compile_options(sim PRIVATE
  $<$<CXX_COMPILER_ID:MSVC>:/WX>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Werror>
)

# TODO: 如有需要，请添加测试并安装目标。
add_custom_target(run COMMAND sim DEPENDS sim WORKING_DIRECTORY ${CMAKE_PROJECT_DIR})
