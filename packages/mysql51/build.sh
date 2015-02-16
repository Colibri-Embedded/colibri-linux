P_VER_MAJ=5.1
P_VERSION=${P_VER_MAJ}.73
P_SRC="mysql-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://downloads.skysql.com/archives/mysql-${P_VER_MAJ}"
P_DEPENDENCIES="ncurses readline"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_NCURSES_PATH="${DDIR}/../ncurses/_install"
	X_READLINE_PATH="${DDIR}../readline/_install"
	
	X_MAKE_ARGS=""
	
	# Build some executables for the host platform used during the
	# cross-compile build process later on
	./configure \
		--with-embedded-server \
		--disable-mysql-maintainer-mode
	
	make ${X_MAKE_ARGS} -C include my_config.h
	make ${X_MAKE_ARGS} -C mysys libmysys.a
	make ${X_MAKE_ARGS} -C strings libmystrings.a
	make ${X_MAKE_ARGS} -C vio libvio.a
	make ${X_MAKE_ARGS} -C dbug libdbug.a
	make ${X_MAKE_ARGS} -C regex libregex.a
	make ${X_MAKE_ARGS} -C sql gen_lex_hash
		
	# Copy gen_lex_hash to a safe location and update PATH
	mkdir -p host_compiled
	cp sql/gen_lex_hash host_compiled
	
	make ${X_MAKE_ARGS} -C scripts comp_sql
	make ${X_MAKE_ARGS} -C extra comp_err
	# Save comp_sql and comp_err compiled for the host
	cp scripts/comp_sql host_compiled/
	cp extra/comp_err   host_compiled/
    
    export PATH=$PATH:$PWD/host_compiled
	
	make distclean
	
	# Build cross-compiled mysql
	export ac_cv_sys_restartable_syscalls=yes
	export ac_cv_path_PS=/bin/ps
	export ac_cv_FIND_PROC="/bin/ps p \$\$PID | grep -v grep | grep mysqld > /dev/null"
	export ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_GCC=yes
	export ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS=no
	export ac_cv_have_decl_HAVE_IB_GCC_ATOMIC_BUILTINS=yes
	export mysql_cv_new_rl_interface=yes
	export CFLAGS="$(build_cflags $DDIR $P_DEPENDENCIES)"
	export CXXFLAGS="$CFLAGS"
	
	./configure --host=$X_HOST \
		--prefix=${X_PREFIX_DIR} \
		--localstatedir=${X_LOCALSTATE_DIR} \
		--sysconfdir=${X_SYSCONF_DIR}/mysql \
		--with-unix-socket-path=${X_LOCALSTATE_DIR}/mysqld.sock \
        --with-plugins=innobase \
		--without-debug \
		--without-docs \
		--without-man \
		--without-libedit \
		--with-low-memory \
		--enable-thread-safe-client \
		--with-atomic-ops=up \
		--with-embedded-server \
		--disable-mysql-maintainer-mode
	
	make ${X_MAKE_ARGS}
	
	# Error because comp_sql has been recompiled for the TARGET architecture
	cp host_compiled/comp_sql scripts
	make ${X_MAKE_ARGS}
	
	# Error because comp_err has been recompiled for the TARGET architecture
	cp host_compiled/comp_err extra
	exec_with_retry make ${X_MAKE_ARGS}

	if [ "x$?" == "x0" ]; then
		make DESTDIR=${TARGET_DIR} install
		
		# Remove test and bechmark programs
		rm -rf ${TARGET_DIR}/${X_PREFIX_DIR}/mysql-test ${TARGET_DIR}/${X_PREFIX_DIR}/sql-bench
	else
		echo "Build failed."
		exit 1
	fi
}

do_post_install()
{
	true
}

do_commands $@
