#!/bin/bash

# run_mingw.sh
# Запуск UDP чата (сборка MinGW)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Определяем корневую директорию
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN_PATH="$PROJECT_ROOT/bin_mingw"

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}UDP Chat - MinGW Runner${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

if [ ! -f "$BIN_PATH/udp_server.exe" ] || [ ! -f "$BIN_PATH/udp_client.exe" ]; then
    echo -e "${RED}✗ Executables not found. Please run:${NC}"
    echo -e "${YELLOW}  cd $PROJECT_ROOT/scripts/windows${NC}"
    echo -e "${YELLOW}  ./build_mingw.sh${NC}"
    exit 1
fi

echo -e "${GREEN}Starting UDP Chat...${NC}"
echo ""

# Запуск в новых окнах
cd "$BIN_PATH"

if command -v wt &> /dev/null; then
    echo -e "${YELLOW}Using Windows Terminal${NC}"
    wt -d "$BIN_PATH" new-tab --title "UDP Server" powershell -Command "./udp_server.exe; Read-Host 'Press Enter to exit'"
    sleep 1
    wt -d "$BIN_PATH" new-tab --title "UDP Client" powershell -Command "./udp_client.exe; Read-Host 'Press Enter to exit'"
else
    echo -e "${YELLOW}Using CMD windows${NC}"
    start cmd /k "cd /d $BIN_PATH && echo UDP SERVER && echo Press Ctrl+C to stop && echo. && udp_server.exe"
    sleep 1
    start cmd /k "cd /d $BIN_PATH && echo UDP CLIENT && echo Type 'end' to quit && echo. && udp_client.exe"
fi

echo ""
echo -e "${GREEN}✓ Both server and client are running!${NC}"
echo ""