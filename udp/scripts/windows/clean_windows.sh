#!/bin/bash

# clean_windows.sh
# Очистка всех сгенерированных файлов для Windows

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Определяем корневую директорию
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Cleaning UDP Chat Project (Windows)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

cd "$PROJECT_ROOT"

# Директории для удаления
DIRS_TO_CLEAN=("build_mingw" "build_msvc" "bin_mingw" "bin_msvc" ".vs" "out")

for dir in "${DIRS_TO_CLEAN[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Removing directory: $dir${NC}"
        rm -rf "$dir"
        echo -e "${GREEN}  ✓ Removed${NC}"
    fi
done

# Файлы для удаления
FILES_TO_CLEAN=("CMakeCache.txt" "cmake_install.cmake" "Makefile" "*.sln" "*.vcxproj" "*.vcxproj.filters" "*.vcxproj.user")

for pattern in "${FILES_TO_CLEAN[@]}"; do
    for file in $pattern; do
        if [ -f "$file" ]; then
            echo -e "${YELLOW}Removing file: $file${NC}"
            rm -f "$file"
            echo -e "${GREEN}  ✓ Removed${NC}"
        fi
    done
done

echo ""
echo -e "${GREEN}✓ Cleanup completed!${NC}"