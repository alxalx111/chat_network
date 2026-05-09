#ifndef COMMON_H
#define COMMON_H

#include <iostream>
#include <cstdlib>
#include <cstring>
#include <stdexcept>

#define MESSAGE_LENGTH 1024
#define PORT 8888 // Другой порт для TCP

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#pragma comment(lib, "ws2_32.lib")

#define close(sock) closesocket(sock)
#define read(sock, buf, len) recv(sock, buf, len, 0)
#define write(sock, buf, len) send(sock, buf, len, 0)

typedef int socklen_t;

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
#include <netinet/in.h>

typedef int SOCKET;
#define INVALID_SOCKET (-1)
#define SOCKET_ERROR (-1)
#endif

#endif // COMMON_H