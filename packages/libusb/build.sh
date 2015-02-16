P_MAJOR_VERSION=1.0
P_VERSION=${P_MAJOR_VERSION}.19
P_SRC="libusb-$P_VERSION"
P_TAR="$P_SRC.tar.bz2"
P_URL="http://downloads.sourceforge.net/project/libusb/libusb-${P_MAJOR_VERSION}/libusb-${P_VERSION}"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--disable-udev
	
	make ${X_MAKE_ARGS}
	make DESTDIR="${TARGET_DIR}" install
}

do_post_install()
{
	# Remove static libraries
	rm ${TARGET_DIR}/usr/lib/*.a
}

do_commands $@
