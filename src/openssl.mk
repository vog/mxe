# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# openssl
PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0a
$(PKG)_CHECKSUM := b837a9f75a51f456bd533690cf04d3d5714812dc
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.openssl.org/
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.openssl.org/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openssl.org/source/' | \
    grep '<a href="openssl-' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # although ws3_32 is used, winsock 1 headers are still referenced
    find '$(1)' -type f -exec \
        $(SED) -i 's,winsock\.h,winsock2.h,g' {} \;

    cd '$(1)' && CC='$(TARGET)-gcc' ./Configure \
        mingw \
        zlib \
        no-shared \
        no-capieng \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install -j 1 \
        CC='$(TARGET)-gcc' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar rcu'
endef
