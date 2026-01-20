cmake_minimum_required(VERSION 3.14)
project(snacks_app LANGUAGES CXX)

set(BINARY_NAME "snacks_app")
set(APPLICATION_ID "com.example.snacks_app")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

add_subdirectory(${FLUTTER_MANAGED_DIR})

add_executable(${BINARY_NAME}
  "MainFlutterWindow.swift"
  "AppDelegate.swift"
)

apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter)

add_dependencies(${BINARY_NAME} flutter_assemble)
