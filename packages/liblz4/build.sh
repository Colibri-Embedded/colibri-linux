P_MAJOR_VERSION=
P_VERSION=
P_SRC="liblz4"
P_TAR=
P_URL=
P_DEPENDENCIES="lz4"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	true
}

do_post_install()
{
	X_LZ4_PATH="${DDIR}/../lz4/_install"
	cp -aRf ${X_LZ4_PATH}/* ${TARGET_DIR}
	rm -rf ${TARGET_DIR}/usr/bin
	rm -rf ${TARGET_DIR}/usr/share

}

do_commands $@
