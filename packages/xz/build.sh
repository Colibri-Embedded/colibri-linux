P_VERSION=5.0.5
P_SRC="xz-$P_VERSION"
P_TAR="$P_SRC.tar.bz2"
P_URL="http://tukaani.org/xz"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{    
    
    export ac_cv_prog_cc_c99='-std=gnu99'
    
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
