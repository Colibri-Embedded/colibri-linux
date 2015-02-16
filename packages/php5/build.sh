P_VERSION=5.5.17
P_SRC="php-$P_VERSION"
P_TAR="$P_SRC.tar.xz"
P_URL="http://www.php.net/distributions"
P_DEPENDENCIES="gettext icu openssl libmcrypt libxml2 zlib pcre libcurl sqlite3 mysql51"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_XML2_PATH="${DDIR}/../libxml2/_install"
	X_MYSQL_PATH="${DDIR}/../mysql51/_install"
	X_GETTEXT_PATH="${DDIR}/../gettext/_install"
	X_MCRYPT_PATH="${DDIR}/../libmcrypt/_install"
	X_ICU_PATH="${DDIR}/../icu/_install"
	X_CURL_PATH="${DDIR}/../libcurl/_install"

	export CC=$X_CC
	export CXX=$X_CXX
	export AR=$X_AR
	export LD=$X_LD
	export RANLIB=$X_RANLIB
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES) -I${X_XML2_PATH}/usr/include/libxml2 -ldl -lmcrypt -lstdc++ -lssl -lcrypto"
	export CXXFLAGS="$CFLAGS"
	export ac_cv_func_dlopen=yes
	export ac_cv_lib_dl_dlopen=yes
	
	./configure ${TARGET_CONF_OPTS} \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-config-file-path="${X_SYSCONF_DIR}/php5" \
		--disable-rpath \
		--disable-fpm \
		--disable-opcache \
		--without-pear \
		--enable-filter \
		--enable-calendar \
		--enable-ctype \
		--enable-dom \
		--enable-fileinfo \
		--enable-ftp \
		--disable-phar \
		--enable-posix \
		--enable-shmop \
		--enable-simplexml \
		--enable-sysvmsg \
		--enable-sysvsem \
		--enable-tokenizer \
		--enable-mbstring \
		--with-mcrypt="${X_MCRYPT_PATH}/usr" \
		--disable-wddx \
		--enable-xmlreader \
		--enable-xmlwriter \
		--enable-opcache=no \
		--enable-pcntl \
		--enable-cgi \
		--enable-json \
		--with-iconv \
		--with-icu-dir="${X_ICU_PATH}/usr" \
		--enable-intl \
		--with-gettext="${X_GETTEXT_PATH}/usr" \
		--with-zlib \
		--enable-pdo \
		--with-mysql="${X_MYSQL_PATH}/usr" \
		--with-mysql-sock="/run/mysqld.sock" \
		--with-mysqli="${X_MYSQL_PATH}/usr/bin/mysql_config" \
		--with-pdo-mysql="${X_MYSQL_PATH}/usr" \
		--enable-libxml \
		--with-libxml-dir="${X_XML2_PATH}/usr" \
		--with-pdo-sqlite \
		--with-sqlite3 \
		--enable-sockets \
		--enable-session \
		--with-curl="${X_CURL_PATH}/usr"
		
cat <<EOF > ext/mysqlnd/php_mysqlnd_config.h
#define HAVE_INT8_T 1
#define HAVE_UINT8_T 1
#define HAVE_INT16_T 1
#define HAVE_UINT16_T 1
#define HAVE_INT32_T 1
#define HAVE_UINT32_T 1
#define HAVE_INT64_T 1
#define HAVE_UINT64_T 1
EOF

	make ${X_MAKE_ARGS}
	INSTALL_ROOT=${TARGET_DIR} make install
}

do_post_install()
{
	true
}

do_commands $@
