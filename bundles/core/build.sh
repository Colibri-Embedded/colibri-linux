P_VERSION=v$(date +%Y%m%d)
P_ORDER="001"
P_SRC="core"
P_OUTPUT="${P_ORDER}-${P_SRC}-${P_VERSION}.cb"
P_COMPRESSION="xz"
P_DEPENDENCIES="\
rootfs \
libc \
busybox \
ncurses \
readline \
zlib \
sudo \
nano \
"

source ../../scripts/env.sh ../../scripts

do_build()
{
	mkdir -p ${TARGET_DIR}
	copy_to_from_others ${TARGET_DIR} ${P_DEPENDENCIES}
}

do_post_install()
{
	rm -f ${P_OUTPUT}
	mksquashfs ${TARGET_DIR} ${P_OUTPUT} -comp ${P_COMPRESSION} -b 512K -no-xattrs
	rm -rf ${TARGET_DIR}
}

do_commands $@
