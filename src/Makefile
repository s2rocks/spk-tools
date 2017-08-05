PKG_CONFIG ?= pkg-config
LUASPK ?= 

OPENSSL_CFLAGS		:= $(shell $(PKG_CONFIG) --cflags openssl)
OPENSSL_LIBS		:= $(shell $(PKG_CONFIG) --libs openssl)

ZLIB_CFLAGS		:= $(shell $(PKG_CONFIG) --cflags zlib)
ZLIB_LIBS		:= $(shell $(PKG_CONFIG) --libs zlib)

FETCH_LIBS		:= $(shell $(CC) -print-file-name=libfetch.a)

# lua module
ifneq ($(LUASPK),)
LUA_VERSION		?= 5.2
LUA_PC			?= lua$(LUA_VERSION)
LUA_LIBDIR		?= /usr/lib/lua/$(LUA_VERSION)
LIBSPK			:= YesPlease
shlibs-y		+= spk.so
spk.so-objs		:= lua-spk.o
CFLAGS_lua-spk.o	:= -DSPK_VERSION=\"$(FULL_VERSION)\" \
			   $(shell $(PKG_CONFIG) $(LUA_PC) --cflags)
LUA_LIB-y		:= $(obj)/spk.so
install-LUA_LIB-y	:= $(INSTALLDIR) $(DESTDIR)$(LUA_LIBDIR) && \
			   $(INSTALL) $(LUA_LIB-y) $(DESTDIR)$(LUA_LIBDIR)
endif

progs-y			+= spk
spk-objs		:= apk.o add.o del.o fix.o update.o info.o \
			   search.o upgrade.o cache.o ver.o index.o fetch.o \
			   audit.o verify.o dot.o policy.o stats.o manifest.o

libspk.so-objs		:= common.o database.o package.o archive.o \
			   version.o io.o url.o gunzip.o blob.o hash.o print.o \
			   commit.o solver.o

ifeq ($(TEST),y)
progs-y			+= spk-test
spk-test-objs		:= spk-test.o $(filter-out apk.o, $(spk-objs))
endif

ifeq ($(SHARED_LIBSPK),)
spk-objs		+= $(libspk.so-objs)
spk-test-objs		+= $(libspk.so-objs)
spk.so-objs		+= $(libspk.so-objs)
else
LIBSPK			:= YesPlease
LIBS_spk		:= -lspk
LIBS_spk-test		:= -lspk
LIBS_spk.so		:= -L$(obj) -lspk
endif

ifneq ($(SHARED_LIBSPK),)
shlibs-y		+= libspk.so
LIBSPK-y		:= $(obj)/libspk.so
install-LIBSPK-y	:= $(INSTALLDIR) $(DESTDIR)$(LIBDIR) && \
			   $(INSTALL) $(LIBSPK-y) $(DESTDIR)$(LIBDIR)
endif

CFLAGS_ALL		+= -D_ATFILE_SOURCE -DSPK_VERSION=\"$(FULL_VERSION)\"
CFLAGS_apk.o		:= -DSPK_VERSION=\"$(FULL_VERSION)\"
CFLAGS_spk-static.o	:= -DSPK_VERSION=\"$(FULL_VERSION)\" -DOPENSSL_NO_ENGINE
CFLAGS_spk-test.o	:= -DSPK_VERSION=\"$(FULL_VERSION)\" -DOPENSSL_NO_ENGINE -DTEST_MODE

progs-$(STATIC)		+= spk.static
spk.static-objs		:= $(filter-out apk.o,$(spk-objs)) spk-static.o
LDFLAGS_spk.static	:= -static
LIBS_spk.static		:= -Wl,--as-needed -ldl -Wl,--no-as-needed
LDFLAGS_spk		+= -L$(obj)
LDFLAGS_spk-test	+= -L$(obj)

CFLAGS_ALL		+= $(OPENSSL_CFLAGS) $(ZLIB_CFLAGS)
LIBS			:= -Wl,--as-needed \
				$(FETCH_LIBS) $(OPENSSL_LIBS) $(ZLIB_LIBS) \
			   -Wl,--no-as-needed

$(obj)/spk: $(LIBSPK-y)

$(obj)/spk.so: $(LIBSPK-y)

install: $(obj)/spk $(LIBSPK-y) $(LUA_LIB-y)
	$(INSTALLDIR) $(DESTDIR)$(SBINDIR)
	$(INSTALL) $(obj)/spk $(DESTDIR)$(SBINDIR)
	$(install-LIBSPK-y)
	$(install-LUA_LIB-y)

