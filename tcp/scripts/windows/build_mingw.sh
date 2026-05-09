#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}TCP Chat - Windows MinGW Build${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "Project root: ${PROJECT_ROOT}"
echo ""

cd "$PROJECT_ROOT"

if ! command -v cmake &> /dev/null; then
    echo -e "${RED}✗ CMake not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ CMake found${NC}"

if ! command -v g++ &> /dev/null; then
    echo -e "${RED}✗ g++ not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ g++ found${NC}"

echo ""
echo -e "${YELLOW}Cleaning old build...${NC}"
rm -rf build_mingw bin_mingw

mkdir -p build_mingw
mkdir -p bin_mingw

cd build_mingw
cmake .. -G "MinGW Makefiles" -DCMAKE_CXX_COMPILER=g++
cmake --build . --config Release

if [ -f "tcp_server.exe" ]; then
    cp tcp_server.exe tcp_client.exe ../bin_mingw/
elif [ -f "Release/tcp_server.exe" ]; then
    cp Release/tcp_server.exe Release/tcp_client.exe ../bin_mingw/
fi

cd "$PROJECT_ROOT"

echo ""
echo -e "${GREEN}BUILD SUCCESSFUL!${NC}"
echo -e "${YELLOW}Binaries: ${PROJECT_ROOT}/bin_mingw/${NC}"