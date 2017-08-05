##
# Building spk-tools

-include config.mk

PACKAGE := spk-tools
VERSION := 1.0.0

##
# Default directories

DESTDIR		:=
SBINDIR		:= /sbin
LIBDIR		:= /lib
CONFDIR		:= /etc/spk
MANDIR		:= /usr/share/man
DOCDIR		:= /usr/share/doc/spk

export DESTDIR SBINDIR LIBDIR CONFDIR MANDIR DOCDIR

##
# Top-level rules and targets

targets		:= src/

##
# Include all rules and stuff

include Make.rules

##
# Top-level targets

install:
	$(INSTALLDIR) $(DESTDIR)$(DOCDIR)
	$(INSTALL) README $(DESTDIR)$(DOCDIR)

check test: FORCE
	$(Q)$(MAKE) TEST=y
	$(Q)$(MAKE) -C test

static:
	$(Q)$(MAKE) STATIC=y
