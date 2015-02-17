P_VERSION=3.0.26
P_SRC="dosfstools-${P_VERSION}"
P_TAR="${P_SRC}.tar.xz"
P_URL="http://daniel-baumann.ch/files/software/dosfstools"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{	
	make ${X_MAKE_ARGS} \
		CC=${X_CC} \
		PREFIX=${X_PREFIX_DIR} \
		SBINDIR=${X_SBIN_DIR} 
		
	make DESTDIR=${TARGET_DIR} \
		PREFIX=${X_PREFIX_DIR} \
		SBINDIR=${X_SBIN_DIR} install
}


do_commands $@
