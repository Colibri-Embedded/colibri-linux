P_VERSION=2.08
P_SRC="lzo-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://www.oberhumer.com/opensource/lzo/download"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{       
    ./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--enable-shared=yes
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install

}

do_post_install()
{
	true
}

do_commands $@
