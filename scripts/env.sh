source $1/msg.sh

X_HOST=arm-linux-gnueabihf
X_F77=$X_HOST-gfortran
X_CC=$X_HOST-gcc
X_LD=$X_HOST-ld
X_CXX=$X_HOST-g++
X_AR=$X_HOST-ar
X_STRIP=$X_HOST-strip
X_RANLIB=$X_HOST-ranlib
X_DOWNLOADS=${EMB_LINUX_ROOT}/downloads
X_PACKAGES=${EMB_LINUX_ROOT}/fabbio/packages
X_MAKE_ARGS="-j4"

X_BUNDLE="bundle"
X_SKELETON="skeleton"
X_PREFIX_DIR="/usr"
X_LOCALSTATE_DIR="/run"
X_SYSCONF_DIR="/etc"
X_LOCALSTATE_DIR="/run"

TARGET_CONF_OPTS="--host=$X_HOST --prefix=$X_PREFIX_DIR --sysconfdir=$X_SYSCONF_DIR --localstatedir=$X_LOCALSTATE_DIR --libexecdir=$X_PREFIX_DIR/lib"
HOST_CONF_OPTS="--prefix=$X_PREFIX_DIR --sysconfdir=$X_SYSCONF_DIR --localstatedir=$X_LOCALSTATE_DIR"

check_environment()
{
    echo "TODO"
}

build_dependencies()
{
    msg_info "Building dependencies for ${P_SRC}"
    for dep in $(echo $P_DEPENDENCIES); do
        if [ -d "$X_PACKAGES/$dep/_install" ]; then
            msg_success ">> $dep: OK"
        else
			local this_pwd=$PWD
            cd "$X_PACKAGES/$dep"
            ./build.sh -buildeps
            cd $this_pwd
        fi
    done
}

check_dependencies()
{
    local ALL_OK=yes
    local BUILD_DEPS=no
    
    if [ "x$1" == "x-buildeps" ]; then
        BUILD_DEPS=yes
    fi
    
    msg_info "Checking dependencies for ${P_SRC}"
    for dep in $(echo $P_DEPENDENCIES); do
        if [ -d "$X_PACKAGES/$dep/_install" ]; then
            msg_success ">> $dep: OK"
        else
            msg_error ">> $dep: MISSING"
            ALL_OK=no
        fi
    done
    
    if [ "$ALL_OK" == "no" ]; then
        if [ "$BUILD_DEPS" == "yes" ]; then
            build_dependencies
        else
            echo "Do you want to build the missing packages? (y,N)"
            read answer
            if [ "x$answer" == "xy" ] || [ "x$answer" == "xY" ]; then
                echo "As you wish."
                build_dependencies
            else
                exit 1
            fi
        fi
    fi
}

build_cflags()
{
	BASEDIR="$1/.."
	shift
	local tmp_cflags=""
	for p in $@; do
		tmp_cflags="$tmp_cflags -L$BASEDIR/$p/_install/usr/lib -L$BASEDIR/$p/_install/lib -I$BASEDIR/$p/_install/usr/include"
	done
	echo $tmp_cflags
}

build_cppflags()
{
	BASEDIR="$1/.."
	shift
	local tmp_cflags=""
	for p in $@; do
		tmp_cflags="$tmp_cflags -I$BASEDIR/$p/_install/usr/include"
	done
	echo $tmp_cflags
}

build_ldflags()
{
	BASEDIR="$1/.."
	shift
	local tmp_cflags=""
	for p in $@; do
		tmp_cflags="$tmp_cflags -L$BASEDIR/$p/_install/usr/lib -L$BASEDIR/$p/_install/lib"
	done
	echo $tmp_cflags
}

unpack_package()
{
    if [ "x${P_TAR}" != "x" ]; then
        msg_info "Looking for ${P_TAR}"
        [ ! -f "$X_DOWNLOADS/$P_TAR" ] && do_download
        msg_info "Unpacking ${P_TAR} ."
        if [ "x$P_RAMFS_BUILD" != "x" ]; then
			cd ${TMPFS_DIR}
		fi
        tar xf "$X_DOWNLOADS/$P_TAR"
        cd $P_SRC
    fi
}

apply_patches()
{
    if [ -d "${DDIR}/patches/" ]; then
        msg_info "Applying patches for $P_SRC"
        for p in $(ls ${DDIR}/patches/*.patch); do
            patch -Np1 -i $p
        done
    fi
}

copy_files_from_to()
{
    SRC=$1
    DST=$2
    
    if [ -d "$SRC" ]; then
        if [ ! -d "$DST" ]; then
            mkdir $DST
        fi
        msg_info "Copying files from $SRC to $DST"
        cp -aRf $SRC/* $DST
    fi
}

copy_to_from_others()
{
	DST=$1
	shift
	local tmp_cflags=""
	for p in $@; do
        if [ -d "$X_PACKAGES/$p/_install" ]; then
			SRC="$X_PACKAGES/$p/_install"
			cp -aRf $SRC/* $DST
        fi
	done
}

copy_skeleton()
{
	copy_files_from_to "${DDIR}/${X_SKELETON}" ${TARGET_DIR}
}

copy_bundle()
{
	copy_files_from_to "${DDIR}/${X_BUNDLE}" ${TARGET_DIR}
}

exec_with_retry()
{
    msg_info "Executing: ${@}"
    COUNTER=0
    while [  $COUNTER -lt 10 ]; do
        ${@}
        if [ "$?" == "0" ]; then
            msg_success "Executed succesfully"
            return
        else
            msg_warning "Retry $COUNTER: ${@}"
        fi
        let COUNTER=COUNTER+1 
    done
    
    msg_error "Failed to execute succesfully: ${@}"
    exit 1
}

do_clean()
{
    msg_info "Cleaning $P_SRC"
	rm -rf _install
	rm -rf _host
	rm -rf $P_SRC
	rm -f build.log
}

do_download()
{
    msg_info "Downloading ${P_TAR}"
    if [ "x$P_URL_OUTPUT" != "x" ]; then
		wget --no-check-certificate "$P_URL" -O "$X_DOWNLOADS/$P_URL_OUTPUT"
    else
		wget --no-check-certificate "$P_URL/$P_TAR" -P "$X_DOWNLOADS/"
	fi
}

do_prepare_tmpfs()
{
	mkdir -p $TMPFS_DIR
	mount -t tmpfs -o size=$P_RAMFS_BUILD,mode=1777 tmpfs $TMPFS_DIR
}

do_clean_tmpfs()
{
	#sleep 3
	#umount $TMPFS_DIR
	#rm -rf $TMPFS_DIR
	return
}

do_pre_build()
{
	do_cleanup_env
	
	DDIR=$PWD
	TARGET_DIR="$DDIR/_install"
    HOST_DIR="$DDIR/_host"
    BUILD_DIR="$DDIR/$P_SRC"
    TMPFS_DIR="$DDIR/tmpfs"
    
	if [ "x$P_RAMFS_BUILD" != "x" ]; then
		do_prepare_tmpfs
	fi
    
	unpack_package
	apply_patches
		
    do_build $@
    
    copy_skeleton
    
    do_post_install
    
    copy_bundle
    
	if [ "x$P_RAMFS_BUILD" != "x" ]; then
		do_clean_tmpfs
	fi
}

do_cleanup_env()
{
	unset C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH
}

do_dummy()
{
	echo $@
}

do_commands()
{
	COLLECT=no
	ARGS=""
	CMD=""
	OTHER=""
	while (( "$#" )); do
	
		if [ "$COLLECT" == "yes" ]; then
			ARGS="$ARGS $1"
		fi
	
		if [ "x$CMD" == "x" ]; then
			if [ ! $(echo "$1" | grep -E "^-.*") ]; then
				CMD=$1
			else
				if [ "$1" != "-args" ]; then
					OTHER="$OTHER $1"
				fi
			fi
		else
			if [ "$COLLECT" == "no" ]; then
				OTHER="$OTHER $1"
			fi
		fi
		
		if [ "$1" == "-args" ]; then
			COLLECT=yes
		fi
		
		shift
	done
	
	case $CMD in
		clean)
			do_clean
			;;
		download)
			do_download
			;;
		*)
			if [ "x${P_FORCE_CLEAN}" == "xyes" ]; then
				$0 clean
			fi
			check_dependencies $OTHER
			msg_info "Starting build process for ${P_SRC}"
			do_pre_build $ARGS | tee build.log
			;;
	esac

}
