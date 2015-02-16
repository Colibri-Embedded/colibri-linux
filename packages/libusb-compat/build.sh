P_MAJOR_VERSION=0.1
P_VERSION=${P_MAJOR_VERSION}.5
P_SRC="libusb-compat-$P_VERSION"
P_TAR="$P_SRC.tar.bz2"
P_URL="http://downloads.sourceforge.net/project/libusb/libusb-compat-${P_MAJOR_VERSION}/libusb-compat-${P_VERSION}"
P_DEPENDENCIES="libusb"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_LIBUSB_PATH="${DDIR}/../libusb/_install"
	
	export CFLAGS="-L${X_LIBUSB_PATH}/usr/lib -I${X_LIBUSB_PATH}/usr/include/libusb-1.0"
	
	LIBUSB_1_0_CFLAGS="-L${X_LIBUSB_PATH}/usr/lib -I${X_LIBUSB_PATH}/usr/include/libusb-1.0" \
	LIBUSB_1_0_LIBS="-lusb-1.0" \
	RANLIB=$X_RANLIB ./configure ${TARGET_CONF_OPTS}
	
	make ${X_MAKE_ARGS}
	make DESTDIR="${TARGET_DIR}" install
}

do_post_install()
{
	# Remove static libraries
	rm ${TARGET_DIR}/usr/lib/*.a
}

do_commands $@
