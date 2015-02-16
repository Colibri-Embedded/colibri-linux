P_VERSION=3080600
P_SRC="sqlite-autoconf-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://www.sqlite.org/2014"
P_DEPENDENCIES="readline"

source ../../scripts/env.sh ../../scripts

do_build()
{
	CC=$X_CC \
	LD=$X_LD \
	RANLIB=$X_RANLIB \
	AR=$X_AR \
	CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES) -DSQLITE_DISABLE_LFS -DSQLITE_SECURE_DELETE -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_STAT3 -DSQLITE_ENABLE_UNLOCK_NOTIFY" \
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--enable-threadsafe

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
