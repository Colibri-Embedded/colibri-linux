P_VERSION=3.1
P_SRC="libffi-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="ftp://sourceware.org/pub/libffi"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{
	./configure ${TARGET_CONF_OPTS} \
		--enable-static=no
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	# Move the headers to the usual location, and adjust the .pc file
	# accordingly.
	install -d -m 0755 ${TARGET_DIR}/usr/include
	mv ${TARGET_DIR}/usr/lib/libffi-${P_VERSION}/include/*.h ${TARGET_DIR}/usr/include/
	set '/^includedir.*/d' -e '/^Cflags:.*/d' ${TARGET_DIR}/usr/lib/pkgconfig/libffi.pc
	# Remove headers that are not at the usual location from the target
	rm -rf ${TARGET_DIR}/usr/lib/libffi-*
}

do_commands $@
