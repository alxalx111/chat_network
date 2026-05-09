#!/bin/bash

# build_mingw.sh
# Скрипт для сборки UDP чата на Windows с MinGW (GCC)

set -e

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
echo -e "${CYAN}UDP Chat - Windows MinGW Build Script${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "Project root: ${PROJECT_ROOT}"
echo ""

# Проверка наличия cmake
if ! command -v cmake &> /dev/null; then
    echo -e "${RED}✗ CMake not found${NC}"
    echo -e "${YELLOW}  Please install CMake and add to PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✓ CMake found${NC}"

# Проверка наличия g++
if ! command -v g++ &> /dev/null; then
    echo -e "${RED}✗ g++ not found${NC}"
    echo -e "${YELLOW}  Please install MinGW-w64:${NC}"
    echo -e "${YELLOW}  https://www.mingw-w64.org/ or use:${NC}"
    echo -e "${YELLOW}  pacman -S mingw-w64-x86_64-gcc (in MSYS2)${NC}"
    exit 1
fi

GCC_VERSION=$(g++ --version | head -n1)
echo -e "${GREEN}✓ g++ found: ${GCC_VERSION}${NC}"

# Переход в корень проекта
cd "$PROJECT_ROOT"

# Очистка
echo ""
echo -e "${YELLOW}Cleaning old build directories...${NC}"
rm -rf build_mingw bin_mingw

# Создание директорий
mkdir -p build_mingw
mkdir -p bin_mingw

echo ""
echo -e "${YELLOW}Generating build files for MinGW...${NC}"

# Генерация файлов сборки для MinGW
cd build_mingw
if cmake .. -G "MinGW Makefiles" -DCMAKE_CXX_COMPILER=g++; then
    echo -e "${GREEN}✓ CMake configuration successful${NC}"
else
    echo -e "${RED}✗ CMake configuration failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Building project...${NC}"

# Сборка
if cmake --build . --config Release; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Копирование бинарников
if [ -f "udp_server.exe" ]; then
    cp udp_server.exe udp_client.exe ../bin_mingw/
    echo -e "${GREEN}✓ Executables copied to bin_mingw/${NC}"
elif [ -f "Release/udp_server.exe" ]; then
    cp Release/udp_server.exe Release/udp_client.exe ../bin_mingw/
    echo -e "${GREEN}✓ Executables copied from Release/${NC}"
fi

cd "$PROJECT_ROOT"

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}BUILD SUCCESSFUL!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Executables location: ${PROJECT_ROOT}/bin_mingw/${NC}"
echo -e "${WHITE}  - udp_server.exe${NC}"
echo -e "${WHITE}  - udp_client.exe${NC}"
echo ""
echo -e "${YELLOW}To run:${NC}"
echo -e "${WHITE}  cd ${PROJECT_ROOT}/bin_mingw${NC}"
echo -e "${WHITE}  ./udp_server.exe${NC}"
echo -e "${WHITE}  ./udp_client.exe${NC}"
echo ""