P_MAJOR_VERSION=2.7
P_VERSION=${P_MAJOR_VERSION}.8
P_SRC="Python-$P_VERSION"
P_TAR="$P_SRC.tar.xz"
P_URL="http://python.org/ftp/python/${P_VERSION}"
P_DEPENDENCIES="libffi readline ncurses sqlite3 openssl zlib"

source ../../scripts/env.sh ../../scripts

do_build_host()
{
	export LDFLAGS="${HOST_LDFLAGS} -Wl,--enable-new-dtags"
	#	--enable-static		
	./configure --prefix=/usr \
	--without-cxx-main 	\
	--disable-sqlite3	\
	--disable-tk		\
	--with-expat=system	\
	--disable-curses	\
	--disable-codecs-cjk	\
	--disable-nis		\
	--enable-unicodedata	\
	--disable-dbm		\
	--disable-gdbm		\
	--disable-bsddb		\
	--disable-test-modules	\
	--disable-bz2		\
	--disable-ssl		\
	--disable-pyo-build \
	PYTHON_DISABLE_SSL="1" \
	PYTHON_DISABLE_MODULES="dbm _bsddb gdbm _curses _curses_panel readline _sqlite3 _tkinter _elementtree pyexpat"
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${HOST_DIR} install
	
	ln -sf python2 ${HOST_DIR}/usr/bin/python
	ln -sf python2-config ${HOST_DIR}/usr/bin/python-config
	
	make distclean
}

do_build()
{	
	autoreconf
	
	cp ../setup.py .
	
	do_build_host
	
	touch ./Include/graminit.h ./Python/graminit.c
	
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES) -fdata-sections -ffunction-sections"
	export CXXFLAGS="$X_CFLAGS"
	export LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES) -Wl,--enable-new-dtags"
		
	export ac_cv_have_long_long_format=yes
	export ac_cv_file__dev_ptmx=yes
	export ac_cv_file__dev_ptc=yes
	export ac_cv_working_tzset=yes
	
	export CXX=$X_CXX
	export CPPFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	
	./configure \
		--target=$X_HOST \
		--host=$X_HOST \
		--build=x86_64-linux-gnu \
		--prefix=/usr \
		--with-fpectl \
		--enable-shared \
		--enable-zlib \
		--disable-ipv6 \
		--enable-threads \
		--enable-unicode=ucs4 \
		--infodir="${X_PREFIX_DIR}/share/info" \
		--mandir="${X_PREFIX_DIR}/share/man" \
		--with-libc="" \
		--enable-loadable-sqlite-extensions \
		--without-system-expat \
		--with-system-ffi \
		PYTHON_DISABLE_SSL="1" \
		PYTHON_DISABLE_MODULES="dbm _bsddb gdbm _curses _curses_panel readline _tkinter _elementtree pyexpat"
		
		
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
    
}

do_post_install()
{
    ln -fs python2 ${TARGET_DIR}/usr/bin/python
    rm -rf ${TARGET_DIR}/usr/lib/python2.7/test
}

do_commands $@
