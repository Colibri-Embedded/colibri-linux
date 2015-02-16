P_VERSION=1.0.1i
P_SRC="openssl-${P_VERSION}"
P_TAR="${P_SRC}.tar.gz"
P_URL="https://www.openssl.org/source"
P_DEPENDENCIES="zlib"

source ../../scripts/env.sh ../../scripts

do_build()
{
	# Note: Patent licenses may be needed for you to utilize rc5 or idea methods in your projects.
	# Therefore, these methods have been disabled.
	./Configure linux-armv4 \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			--libdir=/lib \
			threads \
			shared \
			no-idea \
			no-rc5 \
			zlib-dynamic \
			$(build_cflags $DDIR $P_DEPENDENCIES)
	
	# Disable installation of static libraries
	sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
	
	make depend
	
	make ${X_MAKE_ARGS}
	make INSTALL_PREFIX=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
