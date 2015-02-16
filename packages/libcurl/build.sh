P_VERSION=7.37.1
P_SRC="curl-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://curl.haxx.se/download"
P_DEPENDENCIES="openssl zlib"
#P_DEPENDENCIES="openssl gnutls"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_OPENSSL_PATH="${DDIR}/../openssl/_install"
	X_ZLIB_PATH="${DDIR}/../zlib/_install"
	#X_GNUTLS_PATH="${DDIR}/../gnutls/_install"
	
	printf 'Requires: openssl\n' >>${BUILD_DIR}/libcurl.pc.in
	
	autoreconf
	
	export ac_cv_lib_crypto_CRYPTO_lock=yes
	export LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES)"
	export CPPFLAGS="$(build_cppflags $DDIR $P_DEPENDENCIES)"
	export LIBS="-lssl -lcrypto"
	
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--disable-verbose \
		--disable-manual \
		--disable-ntlm-wb \
		--enable-hidden-symbols \
		--with-random=/dev/urandom \
		--with-ca-path=/etc/ssl/certs \
		--with-ssl="${X_OPENSSL_PATH}/usr" \
		--with-zlib \
		--without-libssh2
		#--with-gnutls=
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	#rm -rf ${TARGET_DIR}/usr/bin/curl
	return 
}

do_commands $@
