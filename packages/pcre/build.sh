P_VERSION=8.36
P_SRC="pcre-$P_VERSION"
P_TAR="$P_SRC.tar.bz2"
P_URL="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	./configure --host=$X_HOST \
		--prefix=/usr \
		--enable-jit \
		--enable-shared=yes \
		--enable-static=no \
		CC=$X_CC \
		AR=$X_AR STRIP=$X_STRIP \
		RANLIB=$X_RANLIB
		
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
