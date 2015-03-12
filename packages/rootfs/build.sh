P_SRC="[rootfs]"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{
    RTD="_install"
}

do_post_install()
{
	chmod 1777 _install/tmp
	mknod ${TARGET_DIR}/dev/ptmx c 5 2
}

do_commands $@
