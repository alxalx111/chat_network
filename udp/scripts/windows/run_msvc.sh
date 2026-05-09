#!/bin/bash

# run_msvc.sh
# Запуск UDP чата (сборка MSVC)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}UDP Chat - MSVC Runner${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_PATH="$SCRIPT_DIR/bin_msvc"

if [ ! -f "$BIN_PATH/udp_server.exe" ] || [ ! -f "$BIN_PATH/udp_client.exe" ]; then
    echo -e "${RED}✗ Executables not found. Please run ./build_msvc.sh first.${NC}"
    exit 1
fi

echo -e "${GREEN}Starting UDP Chat...${NC}"
echo ""

# Запуск в новых окнах
if command -v wt &> /dev/null; then
    echo -e "${YELLOW}Using Windows Terminal${NC}"
    wt -d "$BIN_PATH" new-tab --title "UDP Server" cmd /k "udp_server.exe"
    sleep 1
    wt -d "$BIN_PATH" new-tab --title "UDP Client" cmd /k "udp_client.exe"
else
    echo -e "${YELLOW}Using CMD windows${NC}"
    start cmd /k "cd /d $BIN_PATH && echo UDP SERVER && echo Press Ctrl+C to stop && echo. && udp_server.exe"
    sleep 1
    start cmd /k "cd /d $BIN_PATH && echo UDP CLIENT && echo Type 'end' to quit && echo. && udp_client.exe"
fi

echo ""
echo -e "${GREEN}✓ Both server and client are running!${NC}"
echo ""