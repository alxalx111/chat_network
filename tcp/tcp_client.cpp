#include "common.h"

using namespace std;

int main() {
    SOCKET socket_file_descriptor;
    struct sockaddr_in serveraddress;
    int connection;
    char message[MESSAGE_LENGTH];
    
#ifdef _WIN32
    WinsockInitializer winsock;
#endif
    
    socket_file_descriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_file_descriptor == INVALID_SOCKET) {
        cout << "Creation of Socket failed!" << endl;
        exit(1);
    }
    
    memset(&serveraddress, 0, sizeof(serveraddress));
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_addr.s_addr = inet_addr("127.0.0.1");
    serveraddress.sin_port = htons(PORT);
    
    connection = connect(socket_file_descriptor, (struct sockaddr*)&serveraddress, sizeof(serveraddress));
    if (connection == SOCKET_ERROR) {
        cout << "Connection with the server failed!" << endl;
        close(socket_file_descriptor);
        exit(1);
    }
    
    cout << "Connected to server!" << endl;
    
    while (1) {
        memset(message, 0, sizeof(message));
        cout << "Enter the message you want to send to the server: " << endl;
        cin.getline(message, MESSAGE_LENGTH);
        
        if (cin.fail()) {
            cin.clear();
            cin.ignore(10000, '\n');
        }
        
        if (strncmp(message, "end", 3) == 0) {
            write(socket_file_descriptor, message, strlen(message));
            cout << "Client Exit." << endl;
            break;
        }
        
        ssize_t bytes = write(socket_file_descriptor, message, strlen(message));
        if (bytes >= 0) {
            cout << "Data sent to the server successfully!" << endl;
        }
        
        memset(message, 0, sizeof(message));
        read(socket_file_descriptor, message, sizeof(message) - 1);
        cout << "Data received from server: " << message << endl;
    }
    
    close(socket_file_descriptor);
    return 0;
}