#!/bin/bash

# build_linux.sh
# Скрипт для сборки UDP чата на Linux

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
echo -e "${CYAN}UDP Chat - Linux Build Script${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "Project root: ${PROJECT_ROOT}"
echo ""

cd "$PROJECT_ROOT"

# Проверка наличия CMake
if ! command -v cmake &> /dev/null; then
    echo -e "${RED}✗ CMake not found${NC}"
    echo -e "${YELLOW}  Install with: sudo apt-get install cmake${NC}"
    exit 1
fi
echo -e "${GREEN}✓ CMake found${NC}"

# Проверка наличия g++
if ! command -v g++ &> /dev/null; then
    echo -e "${RED}✗ g++ not found${NC}"
    echo -e "${YELLOW}  Install with: sudo apt-get install g++${NC}"
    exit 1
fi
echo -e "${GREEN}✓ g++ found${NC}"

# Очистка старых сборок
echo ""
echo -e "${YELLOW}Cleaning old build directories...${NC}"
rm -rf build bin

# Создание директорий
mkdir -p build
mkdir -p bin

echo ""
echo -e "${YELLOW}Generating build files...${NC}"

# Генерация файлов сборки
cd build
if cmake ..; then
    echo -e "${GREEN}✓ CMake configuration successful${NC}"
else
    echo -e "${RED}✗ CMake configuration failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Building project...${NC}"

# Сборка проекта
if make -j$(nproc); then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Копирование исполняемых файлов
cp udp_server udp_client ../bin/

cd "$PROJECT_ROOT"

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}BUILD SUCCESSFUL!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Executables location: ${PROJECT_ROOT}/bin/${NC}"
echo -e "${WHITE}  - udp_server${NC}"
echo -e "${WHITE}  - udp_client${NC}"
echo ""