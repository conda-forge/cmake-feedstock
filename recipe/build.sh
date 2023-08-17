#!/usr/bin/env bash

# cmake is needed to build cmake

#export CMAKE_URL=https://cmake.org/files/v3.27/cmake-3.27.3-linux-x86_64.tar.gz
#curl %CMAKE_URL% -o cmake-linux.tgz
#tar xz cmake-linux.tgz > nil
#export PATH=$(pwd)/cmake-$PKG_VERSION-$ARCH-$CPU_ARCH/bin:$PATH
#cmake --version

# Build new cmake
set -ex

CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_FIND_ROOT_PATH=${PREFIX} -DCMAKE_INSTALL_RPATH=${PREFIX}/lib"
CMAKE_ARGS="$CMAKE_ARGS -DCURSES_INCLUDE_PATH=${PREFIX}/include -DBUILD_CursesDialog=ON -DCMake_HAVE_CXX_MAKE_UNIQUE:INTERNAL=FALSE"
CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_USE_SYSTEM_CPPDAP=OFF"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
   if [[ "$target_platform" == osx-* ]] && [[ "$MACOSX_DEPLOYMENT_TARGET" == 11.* || "$MACOSX_DEPLOYMENT_TARGET" == "10.15" ]]; then
       CMAKE_ARGS="$CMAKE_ARGS -DCMake_HAVE_CXX_FILESYSTEM=1"
   else
       CMAKE_ARGS="$CMAKE_ARGS -DCMake_HAVE_CXX_FILESYSTEM=0"
   fi
   cmake ${CMAKE_ARGS} \
       -DCMAKE_VERBOSE_MAKEFILE=1 \
       -DCMAKE_INSTALL_PREFIX="$PREFIX" \
       -DCMAKE_USE_SYSTEM_LIBRARIES=ON \
       -DBUILD_QtDialog=OFF \
       -DCMAKE_USE_SYSTEM_LIBRARY_LIBARCHIVE=OFF \
       -DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=OFF \
       -DCMAKE_USE_SYSTEM_CPPDAP=OFF \
       -DCMAKE_USE_SYSTEM_LIBRARY_CPPDAP=OFF \
       . || (cat TryRunResults.cmake; false)
else
  ./bootstrap \
       --verbose \
       --prefix="${PREFIX}" \
       --system-libs \
       --no-qt-gui \
       --no-system-libarchive \
       --no-system-jsoncpp \
       --no-system-cppdap \
       --parallel=${CPU_COUNT} \
       -- \
       ${CMAKE_ARGS}
fi

# CMake automatically selects the highest C++ standard available

make install -j${CPU_COUNT}

