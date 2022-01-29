ARG IMAGE

FROM ${IMAGE} as builder

ARG DEBIAN_FRONTEND=noninteractive

ARG LAPACK=libopenblas-dev

ARG R_VERSION
ARG CONFIG_ARGS="--enable-R-shlib \
  --enable-memory-profiling \
  --with-readline \
  --with-blas \
  --with-lapack \
  --with-tcltk \
  --with-recommended-packages"

ARG PREFIX=/usr/local
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
    ${LAPACK} \
    libpangocairo-* \
    libpaper-utils \
    '^libpcre[2|3]*' \
    libpng16* \
    libreadline-dev \
    libtiff* \
    unzip \
    zip \
    zlib1g \
  && BUILDDEPS="curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    #libpcre2-dev \
    libpng-dev \
    #libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
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

COPY scripts/*.sh /usr/bin/

RUN start.sh

FROM ${IMAGE}

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.com/b-data/r/rsi" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG IMAGE
ARG PREFIX=/usr/local

ENV BASE_IMAGE=${IMAGE}

COPY --from=builder ${PREFIX} ${PREFIX}
