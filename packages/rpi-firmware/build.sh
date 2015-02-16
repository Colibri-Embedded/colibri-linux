P_VERSION=master
P_SRC="firmware-${P_VERSION}"
P_TAR="rpi-firmware-${P_VERSION}.tar.gz"
P_URL="https://github.com/raspberrypi/firmware/archive/${P_VERSION}.tar.gz"
P_URL_OUTPUT="rpi-firmware-${P_VERSION}.tar.gz"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{	
	return
}

do_post_install()
{
	install -d -m 755 ${TARGET_DIR}/usr/bin
	install -d -m 755 ${TARGET_DIR}/usr/sbin
	install -d -m 755 ${TARGET_DIR}/usr/lib
	cp -a ${BUILD_DIR}/hardfp/opt/vc/bin/* ${TARGET_DIR}/usr/bin
	cp -a ${BUILD_DIR}/hardfp/opt/vc/sbin/* ${TARGET_DIR}/usr/sbin
	cp -a ${BUILD_DIR}/hardfp/opt/vc/lib/* ${TARGET_DIR}/usr/lib
	
}

do_commands $@
