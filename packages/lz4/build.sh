P_VERSION=r123
P_SRC="lz4-$P_VERSION"
P_TAR="${P_SRC}.tar.gz"
P_URL="https://github.com/Cyan4973/lz4/archive/${P_VERSION}.tar.gz"
P_URL_OUTPUT="lz4-${P_VERSION}.tar.gz"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{    
	
	export CC="$X_CC"
	export AR="$X_AR"
	export RANLIB="$X_RANLIB"
	
	# disable compilation & installation of static the library
	sed -e '/@$(AR)/d' -i Makefile
	sed -e '/liblz4.a/d' -i Makefile
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install

}

do_post_install()
{
	true
}

do_commands $@
