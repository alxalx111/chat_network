cmake_minimum_required(VERSION 3.10)
project(TCP_Chat)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    add_definitions(-DWIN32_LEAN_AND_MEAN)
    add_definitions(-D_WINSOCK_DEPRECATED_NO_WARNINGS)
    add_definitions(-D_WIN32_WINNT=0x0601)
    set(WS2_LIB ws2_32)
else()
    set(WS2_LIB "")
endif()

add_executable(tcp_server tcp_server.cpp common.h)
target_link_libraries(tcp_server ${WS2_LIB})

add_executable(tcp_client tcp_client.cpp common.h)
target_link_libraries(tcp_client ${WS2_LIB})

if(UNIX)
    target_compile_options(tcp_server PRIVATE -Wall -Wextra)
    target_compile_options(tcp_client PRIVATE -Wall -Wextra)
endif()