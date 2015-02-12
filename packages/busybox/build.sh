P_VERSION=1.22.1
P_SRC="busybox-$P_VERSION"
P_TAR="$P_SRC.tar.bz2"
P_URL="http://www.busybox.net/downloads"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{	
	cp ../busybox-config .config
	
	make ${X_MAKE_ARGS}
	make install
}

do_post_install()
{
    rm ${TARGET_DIR}/linuxrc
    ln -s sbin/init ${TARGET_DIR}/init
    chmod +s ${TARGET_DIR}/bin/busybox
}

do_commands $@
