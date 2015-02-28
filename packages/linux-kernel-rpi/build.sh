P_VERSION=3.16.y
P_SRC="linux-rpi-${P_VERSION}"
P_TAR="${P_SRC}.tar.gz"
P_URL="https://github.com/raspberrypi/linux/archive/rpi-${P_VERSION}.tar.gz"
P_URL_OUTPUT="${P_SRC}.tar.gz"
P_DEPENDENCIES="initramfs"
P_FORCE_CLEAN=yes
#P_RAMFS_BUILD="1500M"

source ../../scripts/env.sh ../../scripts

do_build()
{

	FLAVOUR=rpi
	
	if [ "$#" != "0" ]; then
		FLAVOUR=$1
	fi

	BUILD_DIR="."
	MODULES_DIR="${DDIR}/${FLAVOUR}/_modules"
	HEADERS_DIR="${DDIR}/${FLAVOUR}/_develop"
	TARGET_DIR="${DDIR}/${FLAVOUR}/_install"
	
	#export KBUILD_OUTPUT=${BUILD_DIR}
	
	mkdir -p ${BUILD_DIR}
	mkdir -p ${TARGET_DIR}
	mkdir -p ${HEADERS_DIR}
	mkdir -p ${MODULES_DIR}
	
	cp ${DDIR}/config_${P_VERSION}_${FLAVOUR} .config
	
	sed -e "s@^CONFIG_INITRAMFS_SOURCE=@CONFIG_INITRAMFS_SOURCE=\"${DDIR}/../initramfs/_install\"@" -i .config
	
	make ${X_MAKE_ARGS}
	
	make ${X_MAKE_ARGS} \
		INSTALL_MOD_PATH=${MODULES_DIR} \
		INSTALL_MOD_STRIP=1 \
		modules_install
		
	make ${X_MAKE_ARGS} headers_check
	make ${X_MAKE_ARGS} \
		INSTALL_HDR_PATH=${HEADERS_DIR} \
		headers_install
		
	make ${X_MAKE_ARGS} \
		INSTALL_PATH=${TARGET_DIR} \
		install
	
}

do_post_install()
{
	cp ${BUILD_DIR}/arch/arm/boot/zImage ${TARGET_DIR}
	cp ${BUILD_DIR}/arch/arm/boot/zImage ${X_SDCARD}/kernel.img
	
	cd ${DDIR}
	ln -s rpi/_modules _install
}

do_commands $@
