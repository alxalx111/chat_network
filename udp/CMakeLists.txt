cmake_minimum_required(VERSION 3.10)
project(UDP_Chat)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Определяем платформу

if(WIN32)
    add_definitions(-DWIN32_LEAN_AND_MEAN)
    add_definitions(-D_WINSOCK_DEPRECATED_NO_WARNINGS)
    add_definitions(-D_WIN32_WINNT=0x0601)
    
    # Для Windows подключаем библиотеки Winsock
    set(WS2_LIB ws2_32)
else()
    set(WS2_LIB "")
endif()

# Сервер
add_executable(udp_server udp_server.cpp common.h)
target_link_libraries(udp_server ${WS2_LIB})

# Клиент
add_executable(udp_client udp_client.cpp common.h)
target_link_libraries(udp_client ${WS2_LIB})

# Кроссплатформенные настройки
if(UNIX)
    target_compile_options(udp_server PRIVATE -Wall -Wextra)
    target_compile_options(udp_client PRIVATE -Wall -Wextra)
endif()