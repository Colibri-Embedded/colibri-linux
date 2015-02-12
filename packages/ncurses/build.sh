P_VERSION=5.9
P_SRC="ncurses-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://ftp.gnu.org/pub/gnu/ncurses"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{
	CC=$X_CC CXX=$X_CXX ./configure --host=$X_HOST --prefix=/usr \
		--with-shared \
		--without-debug \
		--without-ada \
		--without-tests \
		--without-manpages

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
	

}

do_post_install()
{
	# Remove static libraries
	rm ${TARGET_DIR}/usr/lib/*.a
}

do_commands $@
