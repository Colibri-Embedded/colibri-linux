P_VERSION=51.2
P_SRC="icu"
P_TAR="$(echo icu4c-${P_VERSION} | sed 's/\./_/g')-src.tgz"
P_URL="http://download.icu-project.org/files/icu4c/${P_VERSION}"
P_DEPENDENCIES=""
#
source ../../scripts/env.sh ../../scripts

do_build_host()
{
	cp -a source source_host
	cd source_host
	
	_TARGET=$TARGET
	
	unset TARGET
	./configure ${HOST_CONF_OPTS} \
		--disable-samples \
		--disable-tests \
		--disable-extras \
		--disable-icuio \
		--disable-layout \
		--disable-renaming
	
	make ${X_MAKE_ARGS}
	#make DESTDIR=${HOST_DIR} install
	
	export TARGET=$_TARGET
	
	cd ..
}

do_build()
{
	
	do_build_host
	
	unset TARGET
	
	cd source
	./configure ${TARGET_CONF_OPTS} \
		--with-cross-build="${DDIR}/icu/source_host" \
		--disable-samples \
		--disable-tests
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	sed -e "s@^prefix=@prefix=${TARGET_DIR}/usr@" -i ${TARGET_DIR}/usr/bin/icu-config
}

do_commands $@
