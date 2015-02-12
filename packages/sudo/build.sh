P_VERSION="1.8.10p3"
P_SRC="sudo-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://www.sudo.ws/sudo/dist"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{	
	export ac_cv_prog_NCURSESW_CONFIG=false
	export ac_cv_lib_magic_magic_open=no
	export CC=$X_CC
	export RANLIB=$X_RANLIB
	export STRIP=$X_STRIP
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	
	./configure ${TARGET_CONF_OPTS} \
        --with-rundir=/var/lib/sudo \
		--without-lecture \
		--without-sendmail \
		--without-umask \
		--with-logging=syslog \
		--without-interfaces \
		--without-pam \
		--with-env-editor
		
	make ${X_MAKE_ARGS}
	make DESTDIR=$TARGET_DIR install
}

do_post_install()
{
	# Ensure the appropriate permissions
	chmod 4755 $TARGET_DIR/usr/bin/sudo
}

do_commands $@
