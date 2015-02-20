P_MAJOR_VERSION=18
P_VERSION=5.${P_MAJOR_VERSION}.2
P_SRC="perl-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://www.cpan.org/src/5.0"

#PERL_INSTALL_STAGING = YES

PERL_CROSS_VERSION=0.8.5
PERL_CROSS_SITE="https://github.com/arsv/perl-cross/archive"
# DO NOT refactor with the github helper (the result is not the same)
#0.8.5.tar.gz
PERL_CROSS_SOURCE="perl-cross-${PERL_CROSS_VERSION}"
PERL_CROSS_URL_OUTPUT="${PERL_CROSS_SOURCE}.tar.gz"
#PERL_CROSS_OLD_POD = perl$(subst .,,$(PERL_CROSS_BASE_VERSION))delta.pod
#PERL_CROSS_NEW_POD = perl$(subst .,,$(PERL_VERSION))delta.pod

source ../../scripts/env.sh ../../scripts

do_download()
{
	msg_info "Downloading ${PERL_CROSS_URL_OUTPUT}"
	download_source $PERL_CROSS_SITE/$PERL_CROSS_VERSION.tar.gz $PERL_CROSS_URL_OUTPUT
}

do_unpack()
{
	[ ! -f "${X_DOWNLOADS}/${PERL_CROSS_URL_OUTPUT}" ] && do_download
	tar xf ${X_DOWNLOADS}/${PERL_CROSS_URL_OUTPUT} -C ${DDIR}/${P_SRC}
	cp -aR ${DDIR}/${P_SRC}/${PERL_CROSS_SOURCE}/* ${DDIR}/${P_SRC}
	rm -rf ${DDIR}/${P_SRC}/${PERL_CROSS_SOURCE}
}

do_build()
{	
	./configure \
		--prefix=/usr \
		--target=${TARGET}
	
	make ${X_MAKE_ARGS}
	#make
	
	make DESTDIR=${TARGET_DIR} install
}

#~ do_post_install()
#~ {
	#~ true
#~ }

do_commands $@
