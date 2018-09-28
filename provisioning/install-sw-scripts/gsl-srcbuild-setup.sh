# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2018: Oliver Schulz.


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/gsl-config"
}


pkg_install() {
    DOWNLOAD_URL="http://ftpmirror.gnu.org/gsl/gsl-${PACKAGE_VERSION}.tar.gz"

    mkdir gsl
    download "${DOWNLOAD_URL}" \
        | tar --strip-components=1 -x -z -f - -C gsl

    cd gsl

    ./configure --prefix="${INSTALL_PREFIX}" --with-pic

    make -j"$(nproc)" all
    make install
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:\$LD_LIBRARY_PATH"
MANPATH="${INSTALL_PREFIX}/man:\$MANPATH"
PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig:\$PKG_CONFIG_PATH"
export PATH LD_LIBRARY_PATH MANPATH PKG_CONFIG_PATH
EOF
}
