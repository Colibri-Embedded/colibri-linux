P_VERSION=v$(date +%Y%m%d)
P_ORDER="002"
P_SRC="kernel-modules"
P_OUTPUT="${P_ORDER}-${P_SRC}-${P_VERSION}.cb"
P_COMPRESSION="xz"
P_DEPENDENCIES="\
linux-kernel-rpi \
"

source ../../scripts/env.sh ../../scripts

do_build()
{
	mkdir -vp ${TARGET_DIR}
	mkdir -vp ${X_BUNDLES}
	copy_to_from_others ${TARGET_DIR} ${P_DEPENDENCIES}
}

do_post_install()
{
	rm -f ${X_BUNDLES}/${P_OUTPUT}
	mksquashfs ${TARGET_DIR} ${X_BUNDLES}/${P_OUTPUT} -comp ${P_COMPRESSION} -b 512K -no-xattrs -noappend
	rm -rf ${TARGET_DIR}
}

do_commands $@
