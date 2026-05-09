#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

rm -rf build bin
mkdir -p build bin

cd build
cmake ..
make -j$(nproc)

cp tcp_server tcp_client ../bin/

echo "Build successful! Binaries in bin/"