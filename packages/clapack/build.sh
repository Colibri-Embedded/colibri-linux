P_VERSION=3.2.1
P_SRC="clapack-$P_VERSION-CMAKE"
P_TAR="$P_SRC.tgz"
P_URL="http://www.netlib.org/clapack"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_host_build()
{
	rm -f CMakeCache.txt
	
	mkdir build-host
	cd build-host
	
	cmake ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="${HOST_DIR}/usr" \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=ON
	
	make ${X_MAKE_ARGS}
	make install
	
	cd ..
}

do_build()
{
	do_host_build
	
	rm -f CMakeCache.txt
	
	mkdir build-target
	cd build-target
	
	cmake ../ \
		-DCMAKE_TOOLCHAIN_FILE="${DDIR}/../../scripts/toolchainfile.cmake" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=ON
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
	
	cd ..
}

do_post_install()
{
	true
}

do_commands $@
