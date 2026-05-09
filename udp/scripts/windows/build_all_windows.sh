#!/bin/bash

# build_all_windows.sh
# Сборка проекта и MSVC, и MinGW

# Определяем корневую директорию проекта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Building UDP Chat for Windows${NC}"
echo -e "${CYAN}Both MSVC and MinGW${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Переход в директорию со скриптами
cd "$SCRIPT_DIR"

# Сборка MinGW
echo -e "${YELLOW}[1/2] Building with MinGW (GCC)...${NC}"
echo ""
if ./build_mingw.sh; then
    echo -e "${GREEN}✓ MinGW build successful${NC}"
else
    echo -e "${RED}✗ MinGW build failed${NC}"
    exit 1
fi

echo ""

# Сборка MSVC
echo -e "${YELLOW}[2/2] Building with MSVC (Visual Studio)...${NC}"
echo ""
if ./build_msvc.sh; then
    echo -e "${GREEN}✓ MSVC build successful${NC}"
else
    echo -e "${RED}✗ MSVC build failed${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}BUILD COMPLETE!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Binaries:${NC}"
echo -e "  MinGW: ${PROJECT_ROOT}/bin_mingw/${NC}"
echo -e "  MSVC:  ${PROJECT_ROOT}/bin_msvc/${NC}"
echo ""
echo -e "${YELLOW}To run MinGW version:${NC}"
echo -e "  ${PROJECT_ROOT}/bin_mingw/udp_server.exe"
echo -e "  ${PROJECT_ROOT}/bin_mingw/udp_client.exe"
echo ""
echo -e "${YELLOW}To run MSVC version:${NC}"
echo -e "  ${PROJECT_ROOT}/bin_msvc/udp_server.exe"
echo -e "  ${PROJECT_ROOT}/bin_msvc/udp_client.exe"
echo ""