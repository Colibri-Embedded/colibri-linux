P_VERSION=1.0.2
P_SRC="fatresize-$P_VERSION"
P_TAR="$P_SRC.tar.bz2"
P_URL="http://sunet.dl.sourceforge.net/project/fatresize/fatresize/${P_VERSION}"
P_DEPENDENCIES="parted libuuid"

source ../../scripts/env.sh ../../scripts

do_build()
{    
	aclocal
	autoreconf
	automake

	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES) -DLIBPARTED_GT_2_4"

	./configure ${TARGET_CONF_OPTS} \
		PARTED_CFLAGS="$(build_cflags $DDIR parted) -DLIBPARTED_GT_2_4" \
		PARTED_LIBS="-lparted -lparted-fs-resize -luuid"

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install

}

do_commands $@
