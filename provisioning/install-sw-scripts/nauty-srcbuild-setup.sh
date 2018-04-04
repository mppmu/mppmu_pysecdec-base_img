# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2018: Oliver Schulz.


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/dreadnaut"
}

pkg_install() {
    DOWNLOAD_URL="http://pallini.di.uniroma1.it/nauty${PACKAGE_VERSION}.tar.gz"

    mkdir nauty
    download "${DOWNLOAD_URL}" \
        | tar --strip-components=1 -x -z -f - -C nauty

    cd nauty

    ./configure

    make -j"$(nproc)"

    mkdir -p "${INSTALL_PREFIX}/bin"
    cp -a \
        dreadnaut \
        "${INSTALL_PREFIX}/bin"
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
export PATH
EOF
}
