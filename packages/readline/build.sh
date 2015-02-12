P_VERSION=6.3
P_SRC="readline-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="ftp://ftp.gnu.org/gnu/readline"
P_DEPENDENCIES=""

source ../../scripts/env.sh ../../scripts

do_build()
{	
	export bash_cv_func_sigsetjmp=yes
	export bash_cv_wcwidth_broken=no

	export CC=$X_CC
	export CXX=$X_CXX
	export AR=$X_AR
	export LD=$X_LD
	export RANLIB=$X_RANLIB
	
	./configure --host=$X_HOST \
		--prefix=/usr \
		--enable-static=no \
		--without-tests \
		--without-manpages
	
	make ${X_MAKE_ARGS}
	make DESTDIR=${TARGET_DIR} install
}

do_post_install()
{
	true
}

do_commands $@
