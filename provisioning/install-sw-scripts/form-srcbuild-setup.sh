# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2016: Oliver Schulz.


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/form"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`

    git clone "https://github.com/${GITHUB_USER}/form"
    cd form


    # Checkout:
    git checkout "${GIT_BRANCH}"

    autoreconf -i
    ./configure --prefix="${INSTALL_PREFIX}"
    make -j"$(nproc)"
    make install
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
MANPATH="${INSTALL_PREFIX}/share/man:\$MANPATH"
export PATH MANPATH
EOF
}
