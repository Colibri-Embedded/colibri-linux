P_VERSION=0.1
P_SRC="[initramfs]"
P_TAR=
P_URL=
P_DEPENDENCIES="busybox-initramfs libc libuuid libblkid libsmartcols libacl libattr zlib liblzo ncurses readline parted fatresize fdisk btrfs-progs"
P_FORCE_CLEAN=yes

source ../../scripts/env.sh ../../scripts

do_build()
{	
	KERNEL_VERSION="3.16.3"
	X_QEMU_KERNEL_PATH="${DDIR}/../qemu-kernel"
	X_RPI_KERNEL_PATH="${DDIR}/../rpi-kernel"
	X_KERNEL_PATH="${X_QEMU_KERNEL_PATH}"
	
	mkdir -p ${TARGET_DIR}
	copy_to_from_others ${TARGET_DIR} \
		$(echo $P_DEPENDENCIES | sed 's/ libc / /')
	
	rm -rf ${TARGET_DIR}/init 
}

do_post_install()
{
	INITRAMFS="${DDIR}/initramfs.img"
	
	mv ${TARGET_DIR}/usr/sbin/* ${TARGET_DIR}/sbin
	mv ${TARGET_DIR}/usr/bin/* ${TARGET_DIR}/bin
	rm -rf ${TARGET_DIR}/usr/bin
	rm -rf ${TARGET_DIR}/usr/sbin
	
	# Remove development files and programs
	rm -f ${TARGET_DIR}/bin/*-config
	rm -f ${TARGET_DIR}/bin/*_config
	
	rm -rf ${TARGET_DIR}/usr/include
	rm -rf ${TARGET_DIR}/usr/lib/pkgconfig
	rm -rf ${TARGET_DIR}/usr/share/{doc,info,man}
	rm -rf ${TARGET_DIR}/usr/lib/*.{la,a}
	
	# Remove unused libraries
	rm ${TARGET_DIR}/usr/lib/lib{form,menu,history,panel,uuid,blkid}.*
	ln -s libuuid.so.1.3.0 ${TARGET_DIR}/lib/libuuid.so
	ln -s libblkid.so.1.1.0 ${TARGET_DIR}/lib/libblkid.so
	#mv ${TARGET_DIR}/usr/lib/* ${TARGET_DIR}/lib/
	#rm -rf ${TARGET_DIR}/usr
	#rm ${TARGET_DIR}/usr/lib/terminfo
	rm -rf ${TARGET_DIR}/usr/share/terminfo
	rm -rf ${TARGET_DIR}/usr/share/{et,ss}
	#ln -s /usr/share/terminfo ${TARGET_DIR}/terminfo
	
	# Remove unused programs
	rm -f ${TARGET_DIR}/bin/{compile_et,mk_cmds}
	rm -f ${TARGET_DIR}/sbin/{parted,partprobe}
	rm -f ${TARGET_DIR}/sbin/{e2*,mke2fs,resize2fs}
	rm -f ${TARGET_DIR}/sbin/mkfs.ext*
	rm -f ${TARGET_DIR}/sbin/fsck.ext*
	rm -f ${TARGET_DIR}/bin/btrfs-{convert,debug-tree,image,find-root,map-logical}
	rm -f ${TARGET_DIR}/bin/btrfs-{show-super,zero-log}
	rm -f ${TARGET_DIR}/bin/{captoinfo,clear,infocmp,infotocap,ncurses5-config}
	rm -f ${TARGET_DIR}/bin/{reset,tabs,tic,toe,tput,tset}
	
	X_LIBC_PATH="${DDIR}/../libc/_install"
	
	cp -a ${X_LIBC_PATH}/lib/ld-2.13.so ${TARGET_DIR}/lib
	cp -a ${X_LIBC_PATH}/lib/ld-linux* ${TARGET_DIR}/lib
	cp -a ${X_LIBC_PATH}/lib/libc{-,.}* ${TARGET_DIR}/lib
	cp -a ${X_LIBC_PATH}/lib/libm{-,.}* ${TARGET_DIR}/lib
	cp -a ${X_LIBC_PATH}/lib/libdl{-,.}* ${TARGET_DIR}/lib
	cp -a ${X_LIBC_PATH}/lib/libpthread{-,.}* ${TARGET_DIR}/lib
	
	$X_STRIP -s ${TARGET_DIR}/lib/*		&> /dev/null
	$X_STRIP -s ${TARGET_DIR}/usr/lib/*	&> /dev/null
	$X_STRIP -s ${TARGET_DIR}/sbin/*	&> /dev/null
	$X_STRIP -s ${TARGET_DIR}/bin/*		&> /dev/null
	
	#ln -s /bin/bash ${TARGET_DIR}/init
	
	mknod ${TARGET_DIR}/dev/console c 5 1
	mknod ${TARGET_DIR}/dev/null c 1 3
	mknod ${TARGET_DIR}/dev/ram0 b 1 0
	mknod ${TARGET_DIR}/dev/tty1 c 4 1
	mknod ${TARGET_DIR}/dev/tty2 c 4 2
	mknod ${TARGET_DIR}/dev/tty3 c 4 3
	mknod ${TARGET_DIR}/dev/tty4 c 4 4
	
	# Copy kernel modules
	#cp -a ${X_QEMU_KERNEL_PATH}/_modules/lib/modules/* ${TARGET_DIR}/lib/modules
	#~ pushd $PWD &> /dev/null
	#~ cd "${X_KERNEL_PATH}/qemu/_modules"
	#~ M="lib/modules/${KERNEL_VERSION}"
	#~ cp -R --parents $M/kernel/fs/squashfs 			${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/aufs	 			${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/ext4				${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/btrfs				${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/f2fs				${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/minix				${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/jbd2				${TARGET_DIR}
	#~ cp -R --parents $M/kernel/fs/mbcache.ko			${TARGET_DIR}
	#~ #cp -R --parents $M/kernel/mm/zsmalloc.ko		${TARGET_DIR}
	#~ cp -R --parents $M/kernel/drivers/block/loop.ko	${TARGET_DIR}
	#~ cp -R --parents $M/kernel/drivers/scsi			${TARGET_DIR}
	#~ cp -R --parents $M/kernel/drivers/net			${TARGET_DIR}
	#~ cp -R --parents $M/kernel/lib/raid6				${TARGET_DIR}
	#~ cp -R --parents $M/kernel/crypto/xor.ko			${TARGET_DIR}
	#~ cp -R --parents $M/modules.*					${TARGET_DIR}
	#~ popd &> /dev/null
	
	chown -R root.root ${TARGET_DIR}
	
	cd ${TARGET_DIR}
	rm -f ${INITRAMFS}
	find . -print | cpio -o -H newc 2>/dev/null | xz -f --extreme --check=crc32  > ${INITRAMFS}
}

do_commands $@
