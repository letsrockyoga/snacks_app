cmake_minimum_required(VERSION 3.14)
project(snacks_app LANGUAGES CXX)

set(BINARY_NAME "snacks_app")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

add_subdirectory(${FLUTTER_MANAGED_DIR})

add_executable(${BINARY_NAME} WIN32
  "runner/main.cpp"
)

apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

add_dependencies(${BINARY_NAME} flutter_assemble)
