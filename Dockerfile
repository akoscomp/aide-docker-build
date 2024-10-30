FROM almalinux:8.10 AS build

RUN dnf -y --nogpgcheck update

RUN dnf -y --nogpgcheck install \
    git \
    make \
    autoconf \
    automake \
    bison \
    flex \
    clang \
    gcc \
    gcc-c++ \
    iputils \
    jq \
    libcurl-devel \
    libtool \
    llvm \
    openssh-clients \
    pcre-devel \
    pkg-config \
    pkgconf-m4 \
    protobuf-compiler \
    wget \
    xz \
    zip

COPY aide/ /src
WORKDIR /src

#RUN ./autogen.sh
