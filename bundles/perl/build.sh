P_VERSION=$(date +%Y%m%d)
P_ORDER="023"
P_SRC="perl"
P_OUTPUT="${P_ORDER}-${P_SRC}-${P_VERSION}.cb"
P_DEPENDENCIES="\
perl5 \
perl-try-tiny \
perl-module-runtime \
perl-strictures \
perl-class-method-modifiers \
perl-sub-exporter-progressive \
perl-devel-globaldestruction \
perl-import-into \
perl-encode-locale \
perl-moo \
slic3r \
"

source ../../scripts/env.sh ../../scripts

do_build()
{
	mkdir -vp ${TARGET_DIR}
	mkdir -vp ${X_BUNDLES}
	copy_to_from_others ${TARGET_DIR} ${P_DEPENDENCIES}
}

do_post_install()
{
	rm -f ${X_BUNDLES}/${P_OUTPUT}
	mksquashfs ${TARGET_DIR} ${X_BUNDLES}/${P_OUTPUT} -comp ${X_COMPRESSION} -b 512K -no-xattrs -noappend
	rm -rf ${TARGET_DIR}
}

do_commands $@
