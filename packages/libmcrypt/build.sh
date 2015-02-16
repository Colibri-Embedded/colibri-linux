P_VERSION=2.5.8
P_SRC="libmcrypt-${P_VERSION}"
P_TAR="${P_SRC}.tar.bz2"
P_URL="http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/${P_VERSION}"
P_DEPENDENCIES=""
#
source ../../scripts/env.sh ../../scripts

do_build()
{
	export CC=$X_CC
	export LD=$X_LD
	export RANLIB=$X_RANLIB
	export STRIP=$X_STRIP
	
	export ac_cv_func_malloc_0_nonnull=yes
	export ac_cv_func_realloc_0_nonnull=yes
	
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
