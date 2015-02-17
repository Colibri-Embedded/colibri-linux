P_VERSION=2.4.47
P_SRC="attr-$P_VERSION"
P_TAR="${P_SRC}.src.tar.gz"
P_URL="http://download.savannah.gnu.org/releases/attr"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{    	
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--enable-shared=yes \
		--enable-gettext=no \
		--disable-static
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install-lib install-dev

}

do_post_install()
{
	rm -rf ${TARGET_DIR}/usr/bin
	rm -rf ${TARGET_DIR}/usr/share/man/man{1,5}
	mkdir -p ${TARGET_DIR}/lib
	chmod -v 755 ${TARGET_DIR}/usr/lib/libattr.so
	mv -v ${TARGET_DIR}/usr/lib/libattr.so.* ${TARGET_DIR}/lib
	ln -sfv ../../lib/libattr.so.1 ${TARGET_DIR}/usr/lib/libattr.so
}

do_commands $@
