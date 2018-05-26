#!/bin/sh
#
##############################################################################
# Example command to build protobuf
##############################################################################
#

set -e

current_dir=`pwd`/`dirname $0`
PROTOBUF_ROOT="$current_dir/../protobuf"

BUILD_OS="macOS"
BUILD_TYPE=Release
# 静态库OFF, 动态库ON
BUILD_SHARED_LIBS="ON"

# PROTOC_PATH="$current_dir/libprotobuf/$BUILD_OS/protobuf/bin/protoc"
PROTOBUF_BUILD_ROOT="$current_dir/libprotobuf/build/$BUILD_OS/protobuf"
PROTOBUF_OUTPUT_ROOT="$current_dir/libprotobuf/$BUILD_OS/protobuf"

rm -rf $PROTOBUF_BUILD_ROOT
mkdir -p $PROTOBUF_BUILD_ROOT
cd $PROTOBUF_BUILD_ROOT

# cmake args.
CMAKE_ARGS=()

CMAKE_ARGS+=("-DCMAKE_INSTALL_PREFIX=$PROTOBUF_OUTPUT_ROOT")
CMAKE_ARGS+=("-Dprotobuf_BUILD_TESTS=OFF")
CMAKE_ARGS+=("-DCMAKE_C_FLAGS=-fPIC")
CMAKE_ARGS+=("-DCMAKE_CXX_FLAGS=-fPIC")
CMAKE_ARGS+=("-DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS")

# If Ninja is installed, prefer it to Make
if [ -x "$(command -v ninja)" ]; then
  CMAKE_ARGS+=("-GNinja")
fi

echo "$PROTOBUF_ROOT/cmake"
cmake "$PROTOBUF_ROOT/cmake" ${CMAKE_ARGS[@]}

if [ "$(uname)" == 'Darwin' ]; then
  cmake --build . -- "-j$(sysctl -n hw.ncpu)" install
else
  cmake --build . -- "-j$(nproc)" install
fi