P_VERSION=1.2.8
P_SRC="zlib-$P_VERSION"
P_TAR="$P_SRC.tar.xz"
P_URL="http://downloads.sourceforge.net/project/libpng/zlib/${P_VERSION}"

source ../../scripts/env.sh ../../scripts

do_build()
{
	rm -rf config.cache
	CFLAGS="-fPIC"
	
	CC=$X_CC ./configure \
		--shared \
		--prefix=/usr
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	# Remove static libraries
	rm -f ${TARGET_DIR}/usr/lib/*.{la,a}
}

do_commands $@
