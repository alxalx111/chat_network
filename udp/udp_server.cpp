#include "common.h"

char buffer[MESSAGE_BUFFER];
char message[MESSAGE_BUFFER];

void processRequest()
{
    SOCKET socket_file_descriptor;
    struct sockaddr_in serveraddress, client;

#ifdef _WIN32
    WinsockInitializer winsock;
#endif

    // Создадим UDP сокет
    socket_file_descriptor = socket(AF_INET, SOCK_DGRAM, 0);
    if (socket_file_descriptor == INVALID_SOCKET)
    {
        std::cerr << "Socket creation failed" << std::endl;
        exit(1);
    }

    // Настройка адреса сервера
    memset(&serveraddress, 0, sizeof(serveraddress));
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddress.sin_port = htons(PORT);

    // Привяжем сокет
    if (bind(socket_file_descriptor, (struct sockaddr *)&serveraddress, sizeof(serveraddress)) < 0)
    {
        std::cerr << "Bind failed" << std::endl;
        close(socket_file_descriptor);
        exit(1);
    }

    std::cout << "SERVER IS LISTENING THROUGH THE PORT: " << PORT << std::endl;

    while (1)
    {
        socklen_t length = sizeof(client);
        memset(buffer, 0, MESSAGE_BUFFER);

        int message_size = recvfrom(socket_file_descriptor, buffer, MESSAGE_BUFFER - 1, 0,
                                    (struct sockaddr *)&client, &length);

        if (message_size == SOCKET_ERROR)
        {
            std::cerr << "Receive failed" << std::endl;
            continue;
        }

        buffer[message_size] = '\0';

        if (strcmp(buffer, "end") == 0)
        {
            std::cout << "Server is Quitting" << std::endl;
            close(socket_file_descriptor);
            exit(0);
        }

        std::cout << "Message Received from Client: " << buffer << std::endl;
        std::cout << "Enter reply message to the client: " << std::endl;

        memset(message, 0, MESSAGE_BUFFER);
        std::cin.getline(message, MESSAGE_BUFFER);

        // Очистка буфера ввода при необходимости
        if (std::cin.fail())
        {
            std::cin.clear();
            std::cin.ignore(10000, '\n');
        }

        int sent_bytes = sendto(socket_file_descriptor, message, (int)strlen(message), 0,
                                (struct sockaddr *)&client, sizeof(client));

        if (sent_bytes != SOCKET_ERROR)
        {
            std::cout << "Message Sent Successfully to the client: " << message << std::endl;
        }
        else
        {
            std::cout << "Failed to send message" << std::endl;
        }

        std::cout << "Waiting for the Reply from Client..!" << std::endl;
    }

    close(socket_file_descriptor);
}

int main()
{
    processRequest();
    return 0;
}