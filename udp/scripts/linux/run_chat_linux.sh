#!/bin/bash

# run_chat_linux.sh
# Запуск UDP чата на Linux

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN_PATH="$PROJECT_ROOT/bin"

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}UDP Chat - Linux Runner${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

if [ ! -f "$BIN_PATH/udp_server" ] || [ ! -f "$BIN_PATH/udp_client" ]; then
    echo -e "${RED}✗ Executables not found. Please run:${NC}"
    echo -e "${YELLOW}  cd $PROJECT_ROOT/scripts/linux${NC}"
    echo -e "${YELLOW}  ./build_linux.sh${NC}"
    exit 1
fi

echo -e "${GREEN}Starting UDP Chat...${NC}"
echo ""

cd "$BIN_PATH"

# Определение доступного терминала
if command -v gnome-terminal &> /dev/null; then
    echo -e "${YELLOW}Using gnome-terminal${NC}"
    gnome-terminal --title="UDP Server" -- bash -c "echo 'UDP SERVER'; echo 'Press Ctrl+C to stop'; echo ''; ./udp_server; exec bash"
    sleep 1
    gnome-terminal --title="UDP Client" -- bash -c "echo 'UDP CLIENT'; echo 'Type '\''end'\'' to quit'; echo ''; ./udp_client; exec bash"
elif command -v konsole &> /dev/null; then
    echo -e "${YELLOW}Using konsole${NC}"
    konsole --new-tab -p tabtitle="UDP Server" -e bash -c "echo 'UDP SERVER'; echo 'Press Ctrl+C to stop'; echo ''; ./udp_server; exec bash"
    sleep 1
    konsole --new-tab -p tabtitle="UDP Client" -e bash -c "echo 'UDP CLIENT'; echo 'Type '\''end'\'' to quit'; echo ''; ./udp_client; exec bash"
elif command -v xterm &> /dev/null; then
    echo -e "${YELLOW}Using xterm${NC}"
    xterm -title "UDP Server" -e bash -c "echo 'UDP SERVER'; echo 'Press Ctrl+C to stop'; echo ''; ./udp_server; exec bash" &
    sleep 1
    xterm -title "UDP Client" -e bash -c "echo 'UDP CLIENT'; echo 'Type 'end' to quit'; echo ''; ./udp_client; exec bash" &
else
    echo -e "${RED}No supported terminal emulator found${NC}"
    echo -e "${YELLOW}Please run manually:${NC}"
    echo -e "  Terminal 1: cd $BIN_PATH && ./udp_server"
    echo -e "  Terminal 2: cd $BIN_PATH && ./udp_client"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Both server and client are running!${NC}"
echo ""