#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN_PATH="$PROJECT_ROOT/bin"

if [ ! -f "$BIN_PATH/tcp_server" ] || [ ! -f "$BIN_PATH/tcp_client" ]; then
    echo "Executables not found. Run build_linux.sh first"
    exit 1
fi

cd "$BIN_PATH"

if command -v gnome-terminal &> /dev/null; then
    gnome-terminal --title="TCP Server" -- bash -c "./tcp_server; exec bash"
    sleep 1
    gnome-terminal --title="TCP Client" -- bash -c "./tcp_client; exec bash"
else
    echo "Open two terminals and run:"
    echo "  Terminal 1: cd $BIN_PATH && ./tcp_server"
    echo "  Terminal 2: cd $BIN_PATH && ./tcp_client"
fi