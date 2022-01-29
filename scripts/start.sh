#!/bin/bash
# Copyright (c) 2021 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

cd /tmp \
  && wget https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz || \
    wget https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz \
  && tar zxf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  && R_PAPERSIZE=letter \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    ./configure ${CONFIG_ARGS} --prefix=${PREFIX} \
  && if [[ "${MODE}" == "install" ]]; then
    make
    make ${MODE}
  elif [[ "${MODE}" == "install-strip" ]]; then
    make
    make ${MODE}
    echo "_R_SHLIB_STRIP_=true" >> ${PREFIX}/lib/R/etc/Renviron.site
  else
    make ${MODE}
  fi
