P_MAJOR_VERSION=
P_VERSION=
P_SRC="libblkid"
P_TAR=
P_URL=
P_DEPENDENCIES="util-linux"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	true
}

do_post_install()
{
	X_UTIL_LINUX_PATH="${DDIR}/../util-linux/_install"
	cp -aRf ${X_UTIL_LINUX_PATH}/lib/libblkid.* ${TARGET_DIR}/lib/
	cp -aRf ${X_UTIL_LINUX_PATH}/usr/lib/libblkid.* ${TARGET_DIR}/usr/lib/
	rm -f ${TARGET_DIR}/usr/lib/*.{a,la}
	cp -aRf ${X_UTIL_LINUX_PATH}/usr/include/blkid ${TARGET_DIR}/usr/include/
	cp -aRf ${X_UTIL_LINUX_PATH}/usr/lib/pkgconfig/blkid.pc ${TARGET_DIR}/usr/lib/pkgconfig/
}

do_commands $@
