P_VERSION=2.2.52
P_SRC="acl-$P_VERSION"
P_TAR="${P_SRC}.src.tar.gz"
P_URL="http://download.savannah.gnu.org/releases/acl"
P_DEPENDENCIES="libattr"

source ../../scripts/env.sh ../../scripts

do_build()
{    
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	export CPPFLAGS="$(build_cppflags $DDIR $P_DEPENDENCIES)"
	export LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES)"
	
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no \
		--enable-shared=yes \
		--disable-static
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install-lib install-dev

}

do_post_install()
{
	rm -rf ${TARGET_DIR}/usr/bin
	rm -rf ${TARGET_DIR}/usr/share/man{1,5}
	mkdir -p ${TARGET_DIR}/lib
	chmod -v 755 ${TARGET_DIR}/usr/lib/libacl.so
	mv -v ${TARGET_DIR}/usr/lib/libacl.so.* ${TARGET_DIR}/lib
	ln -sfv ../../lib/libacl.so.1 ${TARGET_DIR}/usr/lib/libacl.so
}

do_commands $@
