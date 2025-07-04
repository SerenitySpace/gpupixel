#!/bin/bash
# iOS Build Script
set -e  # Exit immediately if a command exits with a non-zero status

echo "===== Starting iOS Build ====="

# Set script variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "${SCRIPT_DIR}/.." && pwd )"
BUILD_DIR="${PROJECT_DIR}/build/ios"
INSTALL_DIR="${PROJECT_DIR}/output"
 
# Create build directory
mkdir -p "${BUILD_DIR}" || {
  echo "Error: Cannot create build directory"
  exit 1
}

# Toolchain path
CMAKE_TOOLCHAIN="${PROJECT_DIR}/cmake/ios.toolchain.cmake"

# Configure project - Using iOS toolchain
echo "Configuring iOS project..."
cmake -B "${BUILD_DIR}" -S "${PROJECT_DIR}" \
  -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN}" \
  -DPLATFORM=OS64 \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" || {
  echo "Error: Project configuration failed"
  exit 2
}

# Build project - Using multi-threaded compilation
echo "Building iOS project..."
cmake --build "${BUILD_DIR}" --config Debug --parallel $(sysctl -n hw.ncpu) || {
  echo "Error: Project build failed"
  exit 3
}

# Install to output directory
echo "Installing to output directory..."
cmake --install "${BUILD_DIR}" --config Debug || {
  echo "Error: Project installation failed"
  exit 4
}

echo "===== iOS Build Complete, Installation Directory: ${INSTALL_DIR} ====="
exit 0  # Exit normally with return code 0 
