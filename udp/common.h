#ifndef COMMON_H
#define COMMON_H

#include <iostream>
#include <cstdlib>
#include <cstring>
#include <stdexcept> 
#define MESSAGE_BUFFER 4096
#define PORT 7777

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#pragma comment(lib, "ws2_32.lib")

// Windows использует SOCKET (беззнаковый тип)
// Для кроссплатформенности используем SOCKET напрямую
#define close(sock) closesocket(sock)

class WinsockInitializer
{
public:
    WinsockInitializer()
    {
        WSADATA wsaData;
        if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
        {
            throw std::runtime_error("WSAStartup failed");
        }
    }
    ~WinsockInitializer()
    {
        WSACleanup();
    }
};
#else
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <cstring>

// В Linux сокет - это int
typedef int SOCKET;
#define INVALID_SOCKET (-1)
#define SOCKET_ERROR (-1)
#endif

#endif // COMMON_H