P_VERSION=2.9.0
P_SRC="libxml2-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="ftp://xmlsoft.org/libxml2"
P_DEPENDENCIES="zlib"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_ZLIB_PATH="${DDIR}/../zlib/_install"

	CC=$X_CC LD=$X_LD RANLIB=$X_RANLIB AR=$X_AR \
	./configure --host=$X_HOST \
		--prefix=/usr \
		--without-python \
		--without-iconv \
		--with-zlib="${X_ZLIB_PATH}"

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	# Remove static libraries
	rm -f ${TARGET_DIR}/usr/lib/*.{la,a}
}

do_commands $@
