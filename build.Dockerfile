ARG IMAGE
ARG PREFIX=/usr/local

FROM ${IMAGE} as builder

ARG DEBIAN_FRONTEND=noninteractive

ARG BLAS=liblapack-dev

ARG R_VERSION
ARG CONFIG_ARGS="--enable-R-shlib \
  --enable-memory-profiling \
  --with-readline \
  --with-blas \
  --with-lapack \
  --with-tcltk \
  --with-recommended-packages"

ARG PREFIX
ARG MODE=install-strip

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    g++ \
    gfortran \
    libbz2-* \
    '^libcurl[3|4]$' \
    libicu* \
    '^libjpeg.*-turbo.*' \
    liblzma* \
    "${BLAS}" \
    libpangocairo-* \
    libpaper-utils \
    '^libpcre[2|3]*' \
    libpng16* \
    libreadline-dev \
    '^libtiff[5|6]$' \
    unzip \
    zip \
    zlib1g \
  && BUILDDEPS="curl \
    default-jdk \
    #libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    #libpcre2-dev \
    libpng-dev \
    #libreadline-dev \
    libtiff-dev \
    #liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    rsync \
    subversion \
    tcl-dev \
    tk-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    texlive-latex-extra \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    wget \
    zlib1g-dev" \
  && apt-get install -y --no-install-recommends $BUILDDEPS

COPY patches/* /tmp/
COPY scripts/*.sh /usr/bin/

RUN start.sh

FROM scratch

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.b-data.ch/r/rsi" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG PREFIX

COPY --from=builder ${PREFIX} ${PREFIX}
