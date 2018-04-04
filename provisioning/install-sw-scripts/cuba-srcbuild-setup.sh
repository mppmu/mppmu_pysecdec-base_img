# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2018: Oliver Schulz.


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/include/cuba.h"
}

pkg_install() {
    DOWNLOAD_URL="http://www.feynarts.de/cuba/Cuba-${PACKAGE_VERSION}.tar.gz"

    mkdir cuba
    download "${DOWNLOAD_URL}" \
        | tar --strip-components=1 -x -z -f - -C cuba

    cd cuba

    CFLAGS="-O3 -fomit-frame-pointer -ffast-math -fno-finite-math-only -fexceptions -fPIC" ./configure --prefix=/opt/cuba

    make install
}


pkg_env_vars() {
cat <<-EOF
EOF
}
