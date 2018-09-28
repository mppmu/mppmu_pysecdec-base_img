FROM nvidia/cuda:10.0-cudnn7-devel-centos7

# User and workdir settings:

USER root
WORKDIR /root


# Install yum/RPM packages:

COPY provisioning/wandisco-centos7-git.repo /etc/yum.repos.d/wandisco-git.repo

RUN true \
    && sed -i '/tsflags=nodocs/d' /etc/yum.conf \
    && yum install -y \
        epel-release \
    && yum groupinstall -y \
        "Development Tools" \
    && yum install -y \
        wget curl rsync \
        p7zip \
        git svn \
    && dbus-uuidgen > /etc/machine-id


# Copy provisioning script(s):

COPY provisioning/install-sw.sh /root/provisioning/


# Install CMake:

COPY provisioning/install-sw-scripts/cmake-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/cmake/bin:$PATH" \
    MANPATH="/opt/cmake/share/man:$MANPATH"

RUN provisioning/install-sw.sh cmake 3.10.2 /opt/cmake


# Add CUDA libraries to LD_LIBRARY_PATH:

ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:/usr/local/cuda/nvvm/lib64:$LD_LIBRARY_PATH"

# Install NVIDIA libcuda and create driver mount directories:

COPY provisioning/install-sw-scripts/nvidia-* provisioning/install-sw-scripts/

RUN true \
    && mkdir -p /usr/local/nvidia /etc/OpenCL/vendors \
    && provisioning/install-sw.sh nvidia-libcuda 396.24 /usr/lib64

# Note: Installed libcuda.so.1 only acts as a kind of stub. To run GPU code,
# NVIDIA driver libs must be mounted in from host to "/usr/local/nvidia"
# (e.g. via nvidia-docker or manually). OpenCL icd directory
# "/etc/OpenCL/vendors" should be mounted in from host as well.


# Install LaTeX:

RUN true \
    && yum install -y \
        texlive-collection-latexrecommended texlive-dvipng texlive-adjustbox texlive-upquote texlive-ulem


# Install Anaconda3:

COPY provisioning/install-sw-scripts/anaconda3-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/anaconda3/bin:$PATH" \
    MANPATH="/opt/anaconda3/share/man:$MANPATH"

RUN true \
    && yum install -y libXdmcp \
    && provisioning/install-sw.sh anaconda3 5.2.0 /opt/anaconda3 \
    && cd /opt/anaconda3/bin && ln -s nosetests nosetests3


# Install Anaconda2:

COPY provisioning/install-sw-scripts/anaconda2-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/anaconda2/bin:$PATH" \
    MANPATH="/opt/anaconda2/share/man:$MANPATH"

RUN true \
    && yum install -y libXdmcp \
    && provisioning/install-sw.sh anaconda2 5.2.0 /opt/anaconda2 \
    && cd /opt/anaconda2/bin && ln -s nosetests nosetests-2.7


# Install GSL:

COPY provisioning/install-sw-scripts/gsl-* provisioning/install-sw-scripts/

RUN true \
    && provisioning/install-sw.sh gsl-srcbuild 2.5 /usr


# Install CLN:

COPY provisioning/install-sw-scripts/cln-* provisioning/install-sw-scripts/

ENV \
    LD_LIBRARY_PATH="/opt/cln/lib:$LD_LIBRARY_PATH" \
    MANPATH="/opt/cln/share/man:$MANPATH" \
    PKG_CONFIG_PATH="/opt/cln/lib/pkgconfig:$PKG_CONFIG_PATH"

RUN true \
    && provisioning/install-sw.sh cln-srcbuild 1.3.4 /opt/cln


# Install GINAC:

COPY provisioning/install-sw-scripts/ginac-* provisioning/install-sw-scripts/

ENV \
    LD_LIBRARY_PATH="/opt/ginac/lib:$LD_LIBRARY_PATH" \
    MANPATH="/opt/ginac/share/man:$MANPATH" \
    PKG_CONFIG_PATH="/opt/ginac/lib/pkgconfig:$PKG_CONFIG_PATH"

RUN true \
    && yum install -y texinfo transfig \
    && provisioning/install-sw.sh ginac-srcbuild 1.7.4 /opt/ginac


# Install Nauty:

COPY provisioning/install-sw-scripts/nauty-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/nauty/bin:$PATH"

RUN true \
    && provisioning/install-sw.sh nauty-srcbuild 26r10 /opt/nauty


# Install Cuba:

COPY provisioning/install-sw-scripts/cuba-* provisioning/install-sw-scripts/

RUN true \
    && provisioning/install-sw.sh cuba-srcbuild 4.2 /opt/cuba


# Install Normaliz:

ENV \
    PATH="/opt/normaliz/bin:$PATH"

RUN true \
    && yum install -y bsdtar \
    && mkdir -p /opt/normaliz/bin \
    && wget -qO- https://github.com/Normaliz/Normaliz/releases/download/v3.6.0/normaliz-3.6.0Linux64.zip \
        | bsdtar --strip-components 1 -C /opt/normaliz/bin -x -v -f - \
    && chmod 755 /opt/normaliz/bin/normaliz


# Install Form:

COPY provisioning/install-sw-scripts/form-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/form/bin:$PATH" \
    MANPATH="/opt/form/share/man:$MANPATH"

RUN true \
    && MARCH=core-avx2 provisioning/install-sw.sh form-srcbuild vermaseren/247d829 /opt/form


# Install Nvidia visual profiler:

RUN true \
    && yum install -y \
        cuda-nvvp-10-0


# Install support for graphical applications:

RUN yum install -y \
        xorg-x11-server-utils mesa-dri-drivers glx-utils \
        xdg-utils


# Install additional packages and clean up:

RUN yum install -y \
        \
        man \
        numactl \
        htop \
        nano vim \
        git-gui gitk \
        valgrind \
        \
        readline-devel \
        graphviz-devel \
        \
        poppler-utils \
        \
        http://linuxsoft.cern.ch/cern/centos/7/cern/x86_64/Packages/parallel-20150522-1.el7.cern.noarch.rpm \
    && yum clean all


# Clean up:

RUN true \
    && yum clean all


# Final steps

CMD /bin/bash
