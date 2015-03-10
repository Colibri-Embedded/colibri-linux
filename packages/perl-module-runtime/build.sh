P_VERSION=0.014
PERL_VERSION=5.18.2
PERL_ARCHNAME=arm
P_SRC="Module-Runtime-$P_VERSION"
P_TAR="$P_SRC.tar.gz"
P_URL="http://search.cpan.org/CPAN/authors/id/Z/ZE/ZEFRAM/"

source ../../scripts/env.sh ../../scripts

do_build()
{
	
	if [ -f Makefile.PL ] ; then
		PERL_MM_USE_DEFAULT=1 \
		PERL_AUTOINSTALL=--skipdeps \
		perl Makefile.PL \
		AR="$X_AR" \
		FULL_AR="$X_AR" \
		CC="$X_CC" \
		OPTIMIZE=" " \
		LD="$X_CC" \
		LDDLFLAGS="-shared $LDFLAGS" \
		DESTDIR=${TARGET_DIR} \
		INSTALLDIRS=vendor \
		INSTALLVENDORLIB=/usr/lib/perl5/site_perl/$PERL_VERSION \
		INSTALLVENDORARCH=/usr/lib/perl5/site_perl/$PERL_VERSION/$PERL_ARCHNAME \
		INSTALLVENDORBIN=/usr/bin \
		INSTALLVENDORSCRIPT=/usr/bin \
		INSTALLVENDORMAN1DIR=/usr/share/man/man1 \
		INSTALLVENDORMAN3DIR=/usr/share/man/man3 
	else
		PERL_MM_USE_DEFAULT=1 \
		perl Build.PL \
		--config ar="X_AR" \
		--config full_ar="X_AR" \
		--config cc="$X_CC" \
		--config ccflags="$CFLAGS" \
		--config optimize=" " \
		--config ld="$X_CC" \
		--config lddlflags="-shared $LDFLAGS" \
		--config ldflags="$LDFLAGS" \
		--destdir ${TARGET_DIR} \
		--installdirs vendor \
		--install_path lib=/usr/lib/perl5/site_perl/$PERL_VERSION \
		--install_path arch=/usr/lib/perl5/site_perl/$PERL_VERSION/$PERL_ARCHNAME \
		--install_path bin=/usr/bin \
		--install_path script=/usr/bin \
		--install_path bindoc=/usr/share/man/man1 \
		--install_path libdoc=/usr/share/man/man3
		# TODO
		#--include_dirs $$(STAGING_DIR)/usr/lib/perl5/$PERL_VERSION/$PERL_ARCHNAME/CORE 
	fi
	
	make ${X_MAKE_ARGS}
	make install
}

#~ do_post_install()
#~ {
	#~ true
#~ }

do_commands $@
