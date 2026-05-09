#!/bin/bash

# build_msvc.sh
# Скрипт для сборки UDP чата на Windows с MSVC (Visual Studio)

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
echo -e "${CYAN}UDP Chat - Windows MSVC Build Script${NC}"
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

# Параметры
GENERATOR="Visual Studio 17 2022"
ARCH="x64"

echo -e "${YELLOW}Using generator: $GENERATOR ($ARCH)${NC}"

# Переход в корень проекта
cd "$PROJECT_ROOT"

# Очистка
echo ""
echo -e "${YELLOW}Cleaning old build directories...${NC}"
rm -rf build_msvc bin_msvc

# Создание директорий
mkdir -p build_msvc
mkdir -p bin_msvc

echo ""
echo -e "${YELLOW}Generating build files for MSVC...${NC}"

# Генерация файлов сборки для MSVC
cd build_msvc
if cmake .. -G "$GENERATOR" -A $ARCH; then
    echo -e "${GREEN}✓ CMake configuration successful${NC}"
else
    echo -e "${RED}✗ CMake configuration failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Building project...${NC}"

# Сборка Release версии
if cmake --build . --config Release; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Копирование бинарников
if [ -f "Release/udp_server.exe" ]; then
    cp Release/udp_server.exe Release/udp_client.exe ../bin_msvc/
    echo -e "${GREEN}✓ Executables copied to bin_msvc/${NC}"
else
    echo -e "${YELLOW}⚠ Executables not found in expected location${NC}"
fi

cd "$PROJECT_ROOT"

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}BUILD SUCCESSFUL!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Executables location: ${PROJECT_ROOT}/bin_msvc/${NC}"
echo -e "${WHITE}  - udp_server.exe${NC}"
echo -e "${WHITE}  - udp_client.exe${NC}"
echo ""
echo -e "${YELLOW}To run:${NC}"
echo -e "${WHITE}  cd ${PROJECT_ROOT}/bin_msvc${NC}"
echo -e "${WHITE}  udp_server.exe${NC}"
echo -e "${WHITE}  udp_client.exe${NC}"
echo ""