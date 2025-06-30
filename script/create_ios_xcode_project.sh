#!/bin/bash
set -e

# 1. 设置变量
PROJECT_NAME="gpupixel_ios"
BUILD_DIR="build_ios"
TOOLCHAIN_FILE="cmake/ios.toolchain.cmake"

# 2. 创建构建目录
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# 3. 运行CMake生成Xcode工程
cmake .. \
  -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake \
  -DPLATFORM=OS64 \
  -DENABLE_BITCODE=0 \
  -DDEPLOYMENT_TARGET=11.0

echo "✅ Xcode iOS 工程已生成在 $BUILD_DIR 目录下"