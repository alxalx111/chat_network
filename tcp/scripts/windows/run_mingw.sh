#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN_PATH="$PROJECT_ROOT/bin_mingw"

if [ ! -f "$BIN_PATH/tcp_server.exe" ] || [ ! -f "$BIN_PATH/tcp_client.exe" ]; then
    echo "Executables not found. Run build_mingw.sh first"
    exit 1
fi

cd "$BIN_PATH"

if command -v wt &> /dev/null; then
    wt -d "$BIN_PATH" new-tab --title "TCP Server" cmd /k "tcp_server.exe"
    sleep 1
    wt -d "$BIN_PATH" new-tab --title "TCP Client" cmd /k "tcp_client.exe"
else
    start cmd /k "cd /d $BIN_PATH && tcp_server.exe"
    sleep 1
    start cmd /k "cd /d $BIN_PATH && tcp_client.exe"
fi