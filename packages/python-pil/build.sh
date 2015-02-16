P_VERSION=1.1.7
P_SRC="Imaging-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://effbot.org/downloads"
P_DEPENDENCIES="python27 zlib"

source ../../scripts/env.sh ../../scripts

do_build()
{	
	X_PYTHON27_PATH="${DDIR}/../python27/_install"
	X_PYSETUPTOOLS_PATH="${DDIR}/../python-setuptools/_install"
	X_PYTHON27="${X_PYTHON27_PATH}/../_host/usr/bin/python2.7"
	X_ZLIB_PATH="${DDIR}/../zlib/_install"
	
	cat ../setup.py | sed "s@ZLIB_ROOT = None@ZLIB_ROOT = \"${X_ZLIB_PATH}/usr/lib\", \"${X_ZLIB_PATH}/usr/include\"@" > setup.py
	
	export CFLAGS="$(build_cflags $DDIR python27)"
	export C=$X_CC
	export LDSHARED="$X_CC -shared"
	export _python_sysroot=${X_PYTHON27_PATH}
	export _python_prefix=/usr
	export _python_exec_prefix=/usr
	export PYTHONPATH=${X_PYTHON27_PATH}/usr/lib/python2.7:${X_PYSETUPTOOLS_PATH}/usr/lib/python2.7:${X_PYTHON27_PATH}/../_host/usr/lib64/python2.7/lib-dynload
	
	${X_PYTHON27} setup.py config 

	${X_PYTHON27} setup.py build

	${X_PYTHON27} setup.py install \
		--prefix=${TARGET_DIR}/usr \
		--root=/ 
}

do_post_install()
{
	true
}

do_commands $@
