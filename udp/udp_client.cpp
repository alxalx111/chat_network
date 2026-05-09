#include "common.h"

char buffer[MESSAGE_BUFFER];
char message[MESSAGE_BUFFER];

void sendRequest()
{
    SOCKET socket_descriptor;
    struct sockaddr_in serveraddress;

#ifdef _WIN32
    WinsockInitializer winsock;
#endif

    // Создадим сокет
    socket_descriptor = socket(AF_INET, SOCK_DGRAM, 0);
    if (socket_descriptor == INVALID_SOCKET)
    {
        std::cerr << "Socket creation failed" << std::endl;
        exit(1);
    }

    // Настройка адреса сервера
    memset(&serveraddress, 0, sizeof(serveraddress));
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_addr.s_addr = inet_addr("127.0.0.1");
    serveraddress.sin_port = htons(PORT);

    std::cout << "CLIENT IS ESTABLISHING A CONNECTION WITH SERVER THROUGH PORT: " << PORT << std::endl;

    while (1)
    {
        std::cout << "Enter a message you want to send to the server: " << std::endl;

        memset(message, 0, MESSAGE_BUFFER);
        std::cin.getline(message, MESSAGE_BUFFER);

        // Очистка буфера ввода при необходимости
        if (std::cin.fail())
        {
            std::cin.clear();
            std::cin.ignore(10000, '\n');
        }

        if (strcmp(message, "end") == 0)
        {
            sendto(socket_descriptor, message, (int)strlen(message), 0,
                   (struct sockaddr *)&serveraddress, sizeof(serveraddress));
            std::cout << "Client work is done.!" << std::endl;
            close(socket_descriptor);
            exit(0);
        }
        else
        {
            int sent_bytes = sendto(socket_descriptor, message, (int)strlen(message), 0,
                                    (struct sockaddr *)&serveraddress, sizeof(serveraddress));

            if (sent_bytes != SOCKET_ERROR)
            {
                std::cout << "Message sent successfully to the server: " << message << std::endl;
            }
            else
            {
                std::cout << "Failed to send message" << std::endl;
                continue;
            }

            std::cout << "Waiting for the Response from Server..." << std::endl;
        }

        memset(buffer, 0, MESSAGE_BUFFER);
        int bytes_received = recvfrom(socket_descriptor, buffer, MESSAGE_BUFFER - 1, 0, nullptr, nullptr);

        if (bytes_received > 0 && bytes_received != SOCKET_ERROR)
        {
            buffer[bytes_received] = '\0';
            std::cout << "Message Received From Server: " << buffer << std::endl;
        }
        else if (bytes_received == SOCKET_ERROR)
        {
            std::cout << "Failed to receive message" << std::endl;
        }
    }

    close(socket_descriptor);
}

int main()
{
    sendRequest();
    return 0;
}