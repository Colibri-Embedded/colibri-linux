# Is part of the cross-compile toolchain
#P_VERSION=3.15
P_SRC="[libc]"
#P_TAR="${P_SRC}.tar.gz"
P_URL=
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{	
	true
}

do_post_install()
{
    # Find toolchain
    ARM_GCC_PATH=`dirname $(which arm-linux-gnueabihf-gcc)`
    ARM_LIBC_PATH="$ARM_GCC_PATH/../arm-linux-gnueabihf/libc/lib/arm-linux-gnueabihf"
    ARM_LIB_PATH="$ARM_GCC_PATH/../arm-linux-gnueabihf/lib"
	
    mkdir -p ${TARGET_DIR}/lib
    # Copy all libc libraries
    cp -a $ARM_LIBC_PATH/* ${TARGET_DIR}/lib
    # Copy libgcc
    cp -a $ARM_LIB_PATH/libgcc_s.* ${TARGET_DIR}/lib
    # Copy libstdc++
    cp -a $ARM_LIB_PATH/libstdc++.* ${TARGET_DIR}/lib
    # Copy libstdc++
    cp -a $ARM_LIB_PATH/libgfortran.* ${TARGET_DIR}/lib
    
    rm -f  ${TARGET_DIR}/lib/*.{a,o,spec,py}
    rm -rf ${TARGET_DIR}/lib/ldscripts
}

do_commands $@
