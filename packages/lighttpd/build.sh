P_VERSION=1.4.35
P_SRC="lighttpd-$P_VERSION"
P_TAR="$P_SRC.tar.xz"
P_URL="http://download.lighttpd.net/lighttpd/releases-1.4.x"
P_DEPENDENCIES="zlib pcre libxml2 openssl sqlite3"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_PCRE_PATH="${DDIR}/../pcre/_install"
	X_MYSQL_PATH="${DDIR}/../mysql51/_install"
	X_XML2_PATH="${DDIR}/../libxml2/_install"
	
	export CC=$X_CC
	export RANLIB=$X_RANLIB
	export STRIP=$X_STRIP
	
    #--with-mysql="${X_MYSQL_PATH}/usr/bin/mysql_config" \  
    
	./configure ${TARGET_CONF_OPTS} \
		--libdir=${X_PREFIX_DIR}/lib/lighttpd \
		--libexecdir=${X_PREFIX_DIR}/lib \
		--enable-shared \
		--with-zlib \
		--without-bzip2 \
		--with-openssl \
		--with-pcre \
		--with-webdav-props --with-webdav-locks \
		--disable-ipv6 \
		PCRECONFIG="${X_PCRE_PATH}/usr/bin/pcre-config" \
		XML_CFLAGS="-L${X_XML2_PATH}/usr/lib -I${X_XML2_PATH}/usr/include/libxml2" \
		XML_LIBS="-lxml2" \
		SQLITE_CFLAGS="$(build_cflags $DDIR sqlite3)" \
		SQLITE_LIBS="-lsqlite3 -ldl -lpthread" \
		CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES) -DHAVE_PCRE_H=1 -DHAVE_LIBPCRE=1 -I${X_PCRE_PATH}/usr/include"
		
	exec_with_retry make ${X_MAKE_ARGS}
	
	make DESTDIR=${TARGET_DIR} install
}


do_post_install()
{
	true
}


do_commands $@
