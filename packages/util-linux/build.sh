P_MAJOR_VERSION=2.25
P_VERSION=${P_MAJOR_VERSION}.1
P_SRC="util-linux-$P_VERSION"
P_TAR="$P_SRC.tar.xz"
P_URL="https://www.kernel.org/pub/linux/utils/util-linux/v${P_MAJOR_VERSION}"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{
	aclocal
	autoconf
	automake
	
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--disable-rpath \
		--without-python \
		--without-ncurses \
		--disable-login --disable-su --disable-sulogin
		
	#--disable-rpath \
	#--disable-makeinstall-chown \
	#--disable-bash-completion \
	#--without-python
		

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
