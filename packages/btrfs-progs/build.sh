P_VERSION=3.16
P_SRC="btrfs-progs-v${P_VERSION}"
P_TAR="btrfs-progs-v${P_VERSION}.tar.xz"
P_URL="https://www.kernel.org/pub/linux/kernel/people/mason/btrfs-progs"
P_DEPENDENCIES="libuuid libblkid libacl libattr zlib liblzo e2fsprogs"

source ../../scripts/env.sh ../../scripts

do_build()
{

	make ${X_MAKE_ARGS} \
		CC="$X_CC" \
		CXX="$X_CXX" \
		LD="$X_LD" \
		RANLIB="$X_RANLIB" \
		DISABLE_DOCUMENTATION=1 \
		CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)" \
		LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES)" \
		CPPFLAGS="$(build_cppflags $DDIR $P_DEPENDENCIES)" \
		all
		
	make DESTDIR=${TARGET_DIR} \
		prefix=/usr \
		CC="$X_CC" \
		CXX="$X_CXX" \
		LD="$X_LD" \
		RANLIB="$X_RANLIB" \
		DISABLE_DOCUMENTATION=1 \
		CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)" \
		LDFLAGS="$(build_ldflags $DDIR $P_DEPENDENCIES)" \
		CPPFLAGS="$(build_cppflags $DDIR $P_DEPENDENCIES)" \
		install
}

do_post_install()
{
	return
	#~ EXCLUDE="usr/sbin/badblocks \
		#~ usr/bin/chattr \
		#~ usr/sbin/dumpe2fs \
		#~ usr/sbin/e2freefrag \
		#~ usr/sbin/e2undo \
		#~ usr/sbin/e4defrag \
		#~ usr/sbin/filefrag \
		#~ usr/sbin/fsck \
		#~ usr/sbin/logsave \
		#~ usr/bin/lsattr \
		#~ usr/sbin/mklost+found \
		#~ usr/bin/uuidgen
		#~ usr/sbin/mkfs.ext{2,3,4} \
		#~ usr/sbin/mkfs.ext4dev \
		#~ usr/sbin/fsck.ext{2,3,4} \
		#~ usr/sbin/fsck.ext4dev \
		#~ usr/sbin/findfs \
		#~ usr/sbin/tune2fs"
	#~ 
	#~ for e in ${EXCLUDE[@]};do
		#~ rm -f ${TARGET_DIR}/$e
	#~ done
	#~ 
	#~ ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext2
	#~ ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext3
	#~ ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext4
	#~ ln -sf mke2fs ${TARGET_DIR}/usr/sbin/mkfs.ext4dev
	#~ 
	#~ ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext2
	#~ ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext3
	#~ ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext4
	#~ ln -sf e2fsck ${TARGET_DIR}/usr/sbin/fsck.ext4dev
}

do_commands $@
