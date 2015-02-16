P_VERSION=2.1.2
P_SRC="setuptools-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://pypi.python.org/packages/source/s/setuptools"
P_DEPENDENCIES="python27"

source ../../scripts/env.sh ../../scripts

do_host_build()
{
	X_HOST_PYTHON27_PATH="${DDIR}/../python27/_host"
	X_HOST_PYTHON27="${X_HOST_PYTHON27_PATH}/../_host/usr/bin/python2.7"
	
	export PYTHONPATH=${X_HOST_PYTHON27_PATH}/usr/lib/python2.7:${X_HOST_PYTHON27_PATH}/../_host/usr/lib64/python2.7/lib-dynload
	export CC=$X_CC
    export LDSHARED="$X_CC -shared"
    	
	${X_HOST_PYTHON27} setup.py config
	${X_HOST_PYTHON27} setup.py build
	${X_HOST_PYTHON27} setup.py install \
		--prefix=${HOST_DIR}/usr \
        --single-version-externally-managed \
		--root=/ 
		
	${X_HOST_PYTHON27} setup.py clean
}

do_build()
{
	X_PYTHON27_PATH="${DDIR}/../python27/_install"
	X_PYTHON27="${X_PYTHON27_PATH}/../_host/usr/bin/python2.7"
	
	do_host_build
	
	export PYTHONPATH=${X_PYTHON27_PATH}/../_host/usr/lib/python2.7:${X_PYTHON27_PATH}/../_host/usr/lib64/python2.7/lib-dynload
	export CC=$X_CC
    export LDSHARED="$X_CC -shared"
	
    
	echo ${X_PYTHON27}
	${X_PYTHON27} setup.py config
	${X_PYTHON27} setup.py build
    ${X_PYTHON27} setup.py install \
        --prefix=${TARGET_DIR}/usr \
        --single-version-externally-managed \
        --root=/
}

do_post_install()
{
	true
}

do_commands $@
