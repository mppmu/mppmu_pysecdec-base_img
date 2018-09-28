# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2018: Oliver Schulz.


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/include/ginac/ginac.h"
}


pkg_install() {
    DOWNLOAD_URL="https://ginac.de/ginac-${PACKAGE_VERSION}.tar.bz2"

    mkdir ginac
    download "${DOWNLOAD_URL}" \
        | tar --strip-components=1 -x -j -f - -C ginac

    cd ginac

    ./configure --prefix="${INSTALL_PREFIX}"

    make -j"$(nproc)" install
}


pkg_env_vars() {
cat <<-EOF
LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:\$LD_LIBRARY_PATH"
MANPATH="${INSTALL_PREFIX}/share/man:\$MANPATH"
PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig:\$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH MANPATH PKG_CONFIG_PATH
EOF
}
