P_VERSION=1.42.11
P_SRC="e2fsprogs-${P_VERSION}"
P_TAR="${P_SRC}.tar.gz"
P_URL="http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v${P_VERSION}/"
P_DEPENDENCIES="libuuid libblkid"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_LIBUUID_PATH="${DDIR}/../libuuid/_install"
	X_LIBBLKID_PATH="${DDIR}/../libuuid/_install"
	
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)" 
	export LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES)" 
	export CPPFLAGS="$(build_cppflags $DDIR $P_DEPENDENCIES)" 
	export LIBS="-luuid -lblkid"
	
	./configure ${TARGET_CONF_OPTS} \
		--enable-elf-shlibs \
		--disable-debugfs \
		--disable-imager \
		--disable-defrag \
		--disable-uuidd \
		--disable-libblkid \
		--disable-libuuid \
		--enable-fsck \
		--disable-e2initrd-helper \
		--disable-testio-debug \
		--disable-nls \
		--disable-rpath

	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install install-libs
}

do_post_install()
{
	
	EXCLUDE="usr/sbin/badblocks \
		usr/bin/chattr \
		usr/sbin/dumpe2fs \
		usr/sbin/e2freefrag \
		usr/sbin/e2undo \
		usr/sbin/e4defrag \
		usr/sbin/filefrag \
		usr/sbin/fsck \
		usr/sbin/logsave \
		usr/bin/lsattr \
		usr/sbin/mklost+found \
		usr/bin/uuidgen
		usr/sbin/mkfs.ext{2,3,4} \
		usr/sbin/mkfs.ext4dev \
		usr/sbin/fsck.ext{2,3,4} \
		usr/sbin/fsck.ext4dev \
		usr/sbin/findfs \
		usr/sbin/tune2fs"
	
	for e in ${EXCLUDE[@]};do
		rm -f ${TARGET_DIR}/$e
	done
	
	ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext2
	ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext3
	ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext4
	ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext4dev
	
	ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext2
	ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext3
	ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext4
	ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext4dev
}

do_commands $@
