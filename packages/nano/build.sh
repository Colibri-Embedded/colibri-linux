P_MAJOR_VERSION=2.3
P_VERSION=${P_MAJOR_VERSION}.6
P_SRC="nano-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://www.nano-editor.org/dist/v${P_MAJOR_VERSION}"
P_DEPENDENCIES="ncurses zlib"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	export ac_cv_prog_NCURSESW_CONFIG=false
	export ac_cv_lib_magic_magic_open=no
	export CC=$X_CC
	export RANLIB=$X_RANLIB
	export STRIP=$X_STRIP
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	
	./configure --host=$X_HOST \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/run \
		--without-slang \
		CURSES_LIB="-lncurses"
		
	make ${X_MAKE_ARGS}
	make DESTDIR=$TARGET_DIR install
}


do_post_install()
{
	true
}

do_commands $@
