P_MAJOR_VERSION=
P_VERSION=
P_SRC="fdisk"
P_TAR=
P_URL=
P_DEPENDENCIES="util-linux libuuid libsmartcols libblkid"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	true
}

do_post_install()
{
	X_UTIL_LINUX_PATH="${DDIR}/../util-linux/_install"
	cp -aRf ${X_UTIL_LINUX_PATH}/sbin/fdisk ${TARGET_DIR}/sbin/fdisk
	cp -aRf ${X_UTIL_LINUX_PATH}/usr/share/man/man8/fdisk.8 ${TARGET_DIR}/usr/share/man/man8/fdisk.8
}

do_commands $@
