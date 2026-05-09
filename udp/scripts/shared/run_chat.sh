#!/bin/bash

# run_chat.sh
# Универсальный запуск (определяет ОС автоматически)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Определение ОС
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux"
    cd "$PROJECT_ROOT/scripts/linux"
    ./run_chat_linux.sh
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "Detected Windows"
    cd "$PROJECT_ROOT/scripts/windows"
    # Выбор версии для запуска
    if [ -f "$PROJECT_ROOT/bin_mingw/udp_server.exe" ]; then
        ./run_mingw.sh
    else
        echo "MinGW build not found, please run build_mingw.sh first"
        exit 1
    fi
else
    echo "Unknown OS: $OSTYPE"
    exit 1
fi