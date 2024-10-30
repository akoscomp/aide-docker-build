FROM almalinux:9 AS build

ENV AIDE_VERSION=0.18.8

RUN dnf -y --nogpgcheck update \
  && dnf -y --nogpgcheck install \
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
    pcre2-devel \
    pkg-config \
    pkgconf-m4 \
    zlib-devel \
    libgcrypt-devel \
    e2fsprogs-libs \
    libgpg-error-devel

COPY libgcrypt.pc /usr/lib64/pkgconfig/
COPY aide.conf /usr/local/etc/

RUN curl -L https://github.com/aide/aide/releases/download/v${AIDE_VERSION}/aide-${AIDE_VERSION}.tar.gz > /aide.tar.gz \
  && tar -xf /aide.tar.gz && rm /aide.tar.gz

WORKDIR /aide-${AIDE_VERSION}

RUN ./configure
RUN make
RUN make install