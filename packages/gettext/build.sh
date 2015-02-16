P_VERSION=0.19.2
P_SRC="gettext-$P_VERSION"
P_TAR="$P_SRC.tar.xz"
P_URL="http://ftp.gnu.org/pub/gnu/gettext"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{    
    # Disable the build of documentation and examples of gettext-tools,
    # and the build of documentation and tests of gettext-runtime.
	sed '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/examples$$//' gettext-tools/Makefile.in
	sed '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/tests$$//' gettext-runtime/Makefile.in
    
    cd gettext-tools
    
	./configure ${HOST_CONF_OPTS} \
        --disable-libasprintf \
        --disable-acl \
        --disable-openmp \
        --disable-rpath \
        --disable-java \
        --disable-native-java \
        --disable-csharp \
        --disable-relocatable \
        --without-emacs
        
	make ${X_MAKE_ARGS}
	make DESTDIR=${HOST_DIR} install
        
    export PATH=$PATH:${HOST_DIR}/bin:${HOST_DIR}/usr/bin:${HOST_DIR}/sbin:${HOST_DIR}/usr/sbin
	
    cd ../gettext-runtime
    
	CC=$X_CC \
	LD=$X_LD \
	RANLIB=$X_RANLIB \
	AR=$X_AR \
	./configure ${TARGET_CONF_OPTS} \
        --disable-libasprintf \
        --disable-acl \
        --disable-openmp \
        --disable-rpath \
        --disable-java \
        --disable-native-java \
        --disable-csharp \
        --disable-relocatable \
        --without-emacs

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
    
	rm -rf ${TARGET_DIR}/usr/share/gettext/ABOUT-NLS
	rmdir --ignore-fail-on-non-empty ${TARGET_DIR}/usr/share/gettext
}

do_post_install()
{
	true
}

do_commands $@
