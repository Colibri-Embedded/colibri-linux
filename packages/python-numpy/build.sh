P_VERSION=1.8.0
P_SRC="numpy-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://downloads.sourceforge.net/numpy"
P_DEPENDENCIES="python27 clapack"

source ../../scripts/env.sh ../../scripts

do_build_host()
{
	
	X_HOST_CLAPACK_PATH="${DDIR}/../clapack/_host"
	
	echo "[DEFAULT]" > site.cfg
	echo "library_dirs = ${X_HOST_CLAPACK_PATH}/usr/lib:${X_HOST_PYTHON27_PATH}/usr/lib:${X_HOST_PYSETUPTOOLS_PATH}/usr/lib" >> site.cfg
	echo "include_dirs = ${X_HOST_CLAPACK_PATH}/usr/include:${X_HOST_PYTHON27_PATH}/usr/include" >> site.cfg
	echo "libraries = blas,lapack" >> site.cfg
	
	export PYTHONPATH=${X_HOST_PYTHON27_PATH}/usr/lib/python2.7:${X_HOST_PYTHON27_PATH}/../_host/usr/lib64/python2.7/lib-dynload:${X_HOST_PYSETUPTOOLS_PATH}/usr/lib/python2.7
	
	${X_HOST_PYTHON27} setup.py config
	
	${X_HOST_PYTHON27} setup.py build --fcompiler=None
	 
	${X_HOST_PYTHON27} setup.py install \
		--prefix=${HOST_DIR}/usr \
		--root=/ 
		
	rm ${HOST_DIR}/usr/lib/python2.7/site-packages/numpy/distutils/fcompiler/gnu.*
	cp ../gnu.py ${HOST_DIR}/usr/lib/python2.7/site-packages/numpy/distutils/fcompiler
	
	
	rm ${HOST_DIR}/usr/lib/python2.7/site-packages/numpy/core/lib/libnpymath.a
	ln -s ${TARGET_DIR}/usr/lib/python2.7/site-packages/numpy/core/lib/libnpymath.a ${HOST_DIR}/usr/lib/python2.7/site-packages/numpy/core/lib/libnpymath.a
		
	${X_PYTHON27} setup.py clean
}

do_build()
{
	X_FAKE_SYSROOT="${DDIR}/_fake"
	X_PYTHON27_PATH="${DDIR}/../python27/_install"
	X_PYSETUPTOOLS_PATH="${DDIR}/../python-setuptools/_install"
	X_CLAPACK_PATH="${DDIR}/../clapack/_install"
	
	X_HOST_PYSETUPTOOLS_PATH="${DDIR}/../python-setuptools/_host"
	X_HOST_PYTHON27_PATH="${DDIR}/../python27/_host"
	X_HOST_PYTHON27="${X_HOST_PYTHON27_PATH}/../_host/usr/bin/python2.7"
	
	do_build_host
	
	rm -rf build
		
	echo "[DEFAULT]" > site.cfg
	echo "library_dirs = ${X_PYTHON27_PATH}/usr/lib:${X_PYSETUPTOOLS_PATH}/usr/lib:${X_CLAPACK_PATH}/usr/lib" >> site.cfg
	echo "include_dirs = ${X_PYTHON27_PATH}/usr/include/python2.7" >> site.cfg
	echo "libraries = blas,lapack" >> site.cfg
	
	export TARGET=$X_HOST
	export CC=$X_CC
	export CXX=$X_CXX
	export F77=$X_F77
	export LD=$X_LD
	export AR=$X_AR
	export RANLIB=$X_RANLIB
	export STRIP=$X_STRIP
	export LDSHARED="$X_CC -shared"
	export CFLAGS="$(build_cflags $DDIR ${P_DEPENDENCIES})"
	export LDSHARED="$X_CC -shared"
	export _python_sysroot=${X_FAKE_SYSROOT}
	export _python_prefix=/usr
	export _python_exec_prefix=/usr
	export PYTHONPATH=${X_PYTHON27_PATH}/usr/lib/python2.7:${X_PYSETUPTOOLS_PATH}/usr/lib/python2.7:${X_PYTHON27_PATH}/../_host/usr/lib64/python2.7/lib-dynload
	
	mkdir ${DDIR}/_fake
	cp -aR ${X_PYTHON27_PATH}/* ${DDIR}/_fake
	cp -aR ${X_HOST_CLAPACK_PATH}/* ${DDIR}/_fake
	
	${X_HOST_PYTHON27} setup.py config
	
	${X_HOST_PYTHON27} setup.py build  --fcompiler=None
	 
	${X_HOST_PYTHON27} setup.py install \
		--prefix=${TARGET_DIR}/usr \
		--root=/ 
		
	rm -rf ${DDIR}/_fake
}

do_post_install()
{
	cp ${TARGET_DIR}/usr/lib/python2.7/site-packages/numpy/distutils/site.cfg ${HOST_DIR}/usr/lib/python2.7/site-packages/numpy/distutils
}

do_commands $@
