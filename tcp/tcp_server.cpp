#include "common.h"

using namespace std;

int main() {
    SOCKET socket_file_descriptor, connection;
    struct sockaddr_in serveraddress, client;
    socklen_t length;
    int bind_status, connection_status;
    char message[MESSAGE_LENGTH];
    
#ifdef _WIN32
    WinsockInitializer winsock;
#endif
    
    socket_file_descriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_file_descriptor == INVALID_SOCKET) {
        cout << "Socket creation failed!" << endl;
        exit(1);
    }
    
    memset(&serveraddress, 0, sizeof(serveraddress));
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddress.sin_port = htons(PORT);
    
    bind_status = bind(socket_file_descriptor, (struct sockaddr*)&serveraddress, sizeof(serveraddress));
    if (bind_status == SOCKET_ERROR) {
        cout << "Socket binding failed!" << endl;
        close(socket_file_descriptor);
        exit(1);
    }
    
    connection_status = listen(socket_file_descriptor, 5);
    if (connection_status == SOCKET_ERROR) {
        cout << "Socket is unable to listen for new connections!" << endl;
        close(socket_file_descriptor);
        exit(1);
    } else {
        cout << "Server is listening for new connection on port " << PORT << endl;
    }
    
    length = sizeof(client);
    connection = accept(socket_file_descriptor, (struct sockaddr*)&client, &length);
    if (connection == INVALID_SOCKET) {
        cout << "Server is unable to accept the data from client!" << endl;
        close(socket_file_descriptor);
        exit(1);
    }
    
    cout << "Client connected!" << endl;
    
    while (1) {
        memset(message, 0, MESSAGE_LENGTH);
        int bytes_read = read(connection, message, sizeof(message) - 1);
        
        if (bytes_read <= 0) {
            cout << "Client disconnected!" << endl;
            break;
        }
        
        if (strncmp(message, "end", 3) == 0) {
            cout << "Client Exited." << endl;
            cout << "Server is Exiting...!" << endl;
            break;
        }
        
        cout << "Data received from client: " << message << endl;
        memset(message, 0, MESSAGE_LENGTH);
        cout << "Enter the message you want to send to the client: " << endl;
        cin.getline(message, MESSAGE_LENGTH);
        
        if (cin.fail()) {
            cin.clear();
            cin.ignore(10000, '\n');
        }
        
        ssize_t bytes = write(connection, message, strlen(message));
        if (bytes >= 0) {
            cout << "Data successfully sent to the client!" << endl;
        }
    }
    
    close(connection);
    close(socket_file_descriptor);
    return 0;
}