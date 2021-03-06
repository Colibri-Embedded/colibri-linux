#
# Automatically generated file; DO NOT EDIT.
# CMake toolchain file for Buildroot
#

# In order to allow the toolchain to be relocated, we calculate the
# HOST_DIR based on this file's location: $(HOST_DIR)/usr/share/buildroot
# and store it in RELOCATED_HOST_DIR.
# All the other variables that need to refer to HOST_DIR will use the
# RELOCATED_HOST_DIR variable.
#string(REPLACE "/usr/share/buildroot" "" RELOCATED_HOST_DIR ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_SYSTEM_NAME Linux)

set(CMAKE_C_FLAGS "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -pipe -mhard-float -Os ${CMAKE_C_FLAGS}" CACHE STRING "Buildroot CFLAGS" FORCE)
set(CMAKE_CXX_FLAGS "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -pipe -mhard-float -Os ${CMAKE_CXX_FLAGS}" CACHE STRING "Buildroot CXXFLAGS" FORCE)
set(CMAKE_INSTALL_SO_NO_EXE 0)

#set(CMAKE_PROGRAM_PATH "${RELOCATED_HOST_DIR}/usr/bin")
#set(CMAKE_FIND_ROOT_PATH "${RELOCATED_HOST_DIR}/usr/arm-buildroot-linux-gnueabihf/sysroot")
#set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
#set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#set(ENV{PKG_CONFIG_SYSROOT_DIR} "${RELOCATED_HOST_DIR}/usr/arm-buildroot-linux-gnueabihf/sysroot")

# This toolchain file can be used both inside and outside Buildroot.
# * When used inside Buildroot, ccache support is explicitly driven using the
#   USE_CCACHE variable.
# * When used outside Buildroot (i.e. when USE_CCACHE is not defined), ccache
#   support is automatically enabled if the ccache program is available.

set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "arm-linux-gnueabihf-g++")

