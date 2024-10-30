FROM almalinux:8.10 AS build

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

RUN ./configure && make && make install 

FROM almalinux:8.10
COPY --from=build /usr/local/bin/aide /usr/local/bin/aide
COPY --from=build /usr/local/share/man/man1/aide.1 /usr/local/share/man/man1/aide.1
COPY --from=build /usr/local/share/man/man5/aide.conf.5 /usr/local/share/man/man5/aide.conf.5

RUN mkdir -p /var/log/aide && touch /var/log/aide/aide.log && mkdir -p /var/lib/aide

COPY aide.conf /usr/local/etc/

RUN aide --init && cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
