#!/bin/bash

# clean_linux.sh
# Очистка всех сгенерированных файлов на Linux

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Cleaning UDP Chat Project (Linux)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

cd "$PROJECT_ROOT"

# Удаление директорий
for dir in build bin; do
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Removing directory: $dir${NC}"
        rm -rf "$dir"
        echo -e "${GREEN}  ✓ Removed${NC}"
    fi
done

# Удаление файлов CMake
for file in CMakeCache.txt cmake_install.cmake Makefile; do
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Removing file: $file${NC}"
        rm -f "$file"
        echo -e "${GREEN}  ✓ Removed${NC}"
    fi
done

echo ""
echo -e "${GREEN}✓ Cleanup completed!${NC}"