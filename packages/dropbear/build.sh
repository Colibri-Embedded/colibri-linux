P_VERSION=2015.67
P_SRC="dropbear-$P_VERSION"
P_TAR="${P_SRC}.tar.bz2"
P_URL="http://matt.ucc.asn.au/dropbear/releases"
P_DEPENDENCIES="zlib libc"

DROPBEAR_PROGRAMS="dropbearkey dropbearconvert dropbear"

source ../../scripts/env.sh ../../scripts

do_build()
{    
	
	export CC="$X_CC"
	export AR="$X_AR"
	export RANLIB="$X_RANLIB"
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	export LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES)"
	export CPPFLAGS="$(build_cppflags $DDIR $P_DEPENDENCIES)"
	
	#sed -e 's/LIBS+=@LIBS@/LIBS+=@CRYPTLIB@ @LIBS@/' -i Makefile.in
	
	#automake
	
	# FIX_XAUTH
	sed -e 's,^#define XAUTH_COMMAND.*/xauth,#define XAUTH_COMMAND "/usr/bin/xauth,g' -i options.h
	# BUILD_FEATURED
	sed -e 's:^#define DROPBEAR_SMALL_CODE::' -i options.h
	sed -e 's:.*\(#define DROPBEAR_BLOWFISH\).*:\1:' -i options.h
	sed -e 's:.*\(#define DROPBEAR_TWOFISH128\).*:\1:' -i options.h
	sed -e 's:.*\(#define DROPBEAR_TWOFISH256\).*:\1:' -i options.h
	# DROPBEAR_ENABLE_REVERSE_DN
	sed -e 's:.*\(#define DO_HOST_LOOKUP\).*:\1:' -i options.h
	#sed -e 's:.*\(#define DROPBEAR_SHA2_256_HMAC\).*:\1:' -i options.h
	#sed -e 's:.*\(#define DROPBEAR_SHA2_512_HMAC\).*:\1:' -i options.h

	
	./configure ${TARGET_CONF_OPTS} \
		--disable-wtmp \
		--disable-lastlog
	
	make ${X_MAKE_ARGS} \
		SCPPROGRESS=1 \
		PROGRAMS="${DROPBEAR_PROGRAMS}"
	
	make DESTDIR=${TARGET_DIR} install

}

do_post_install()
{
	true
}

do_commands $@
