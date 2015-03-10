P_VERSION=0.14.0
P_SRC="scipy-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="https://pypi.python.org/packages/source/s/scipy"
P_DEPENDENCIES="python27 python-numpy"

source ../../scripts/env.sh ../../scripts

do_build()
{
	X_PYTHON27_PATH="${DDIR}/../python27/_install"
	X_PYSETUPTOOLS_PATH="${DDIR}/../python-setuptools/_install"
	X_HOST_CLAPACK_PATH="${DDIR}/../clapack/_host"
	X_CLAPACK_PATH="${DDIR}/../clapack/_install"
	X_NUMPY_PATH="${DDIR}/../python-numpy/_install"
	
	X_HOST_PYTHON27_PATH="${DDIR}/../python27/_host"
	X_HOST_NUMPY_PATH="${DDIR}/../python-numpy/_host"
	X_HOST_PYTHON27="${X_PYTHON27_PATH}/../_host/usr/bin/python2.7"
	
	
	export CC=$X_CC
	export CXX=$X_CXX
	export F77=$X_F77
	export LD=$X_LD
	export AR=$X_AR
	export RANLIB=$X_RANLIB
	export STRIP=$X_STRIP
	export LDSHARED="$X_CC -shared"
	export CFLAGS="$(build_cflags $DDIR python27) -L${X_CLAPACK_PATH}/usr/lib"
	export _python_sysroot=${X_PYTHON27_PATH}
	export _python_prefix=/usr
	export _python_exec_prefix=/usr
	#export PYTHONHOME=$"${X_HOST_PYTHON27_PATH}/usr/lib/python2.7:{X_HOST_PYTHON27_PATH}/usr/lib64/python2.7/lib-dynload"
	#export PYTHONPATH="${X_HOST_PYTHON27_PATH}/usr/lib/python2.7:${X_HOST_PYTHON27_PATH}/usr/lib64/python2.7/lib-dynload"
	export PYTHONPATH="$PYTHONPATH:${X_HOST_PYTHON27_PATH}/usr/lib64/python2.7/lib-dynload"
	#export PYTHONPATH="$PYTHONPATH:${X_CLAPACK_PATH}/usr/lib"
	export PYTHONPATH="$PYTHONPATH:${X_PYSETUPTOOLS_PATH}/usr/lib/python2.7"
	export PYTHONPATH="$PYTHONPATH:${X_HOST_NUMPY_PATH}/usr/lib/python2.7/site-packages"
	#export PYTHONPATH="${X_HOST_PYTHON27_PATH}/usr/lib/python2.7:\
	#				  ${X_HOST_PYTHON27_PATH}/usr/lib64/python2.7/lib-dynload:\
	#				  :\
	#				  "
	
	export LD_LIBRARY_PATH=${X_HOST_CLAPACK_PATH}/usr/lib
	
	${X_HOST_PYTHON27} setup.py config 
	
	export _python_sysroot=${X_PYTHON27_PATH}
	
	#export LD_LIBRARY_PATH="${X_HOST_CLAPACK_PATH}/usr/lib"
	
	export PYTHONPATH="${X_HOST_PYTHON27_PATH}/usr/lib/python2.7"
	export PYTHONPATH="$PYTHONPATH:${X_HOST_PYTHON27_PATH}/usr/lib64/python2.7/lib-dynload"
	export PYTHONPATH="$PYTHONPATH:${X_HOST_NUMPY_PATH}/usr/lib/python2.7/site-packages"

	${X_HOST_PYTHON27} setup.py build --fcompiler=gnu95
	 
	${X_HOST_PYTHON27} setup.py install \
		--prefix=${TARGET_DIR}/usr \
		--root=/ 
}

do_post_install()
{
	true
}

do_commands $@
