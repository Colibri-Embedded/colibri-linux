P_VERSION=3.1
P_SRC="parted-${P_VERSION}"
P_TAR="${P_SRC}.tar.xz"
P_URL="http://ftp.gnu.org/gnu/parted"
P_DEPENDENCIES="ncurses readline libuuid"
P_HOST_DEPENDENCIES="gperf makeinfo(texinfo)"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	if [ "$P_VERSION" == "2.3" ]; then
		for p in $(cat debian/patches/series| sed -e '/#/d');do 
			patch -Np1 -i debian/patches/$p
		done
	
		#https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=741767
		for fix in $(grep -rl "CPPFunction" .);do
			sed -e "s/CPPFunction/rl_completion_func_t/g" -i $fix
		done
	
	fi
	
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	
	./configure --host=$X_HOST \
		--prefix=/usr \
		--localstatedir=/run \
		--sysconfdir=/etc \
		--enable-static=no \
		--enable-shared=yes \
		--with-readline \
		--disable-device-mapper \
		--disable-nls \
		--disable-Werror
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
