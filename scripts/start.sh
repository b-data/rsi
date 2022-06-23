#!/bin/bash
# Copyright (c) 2021 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

# Test if PREFIX location is whithin limits
if [[ ! "${PREFIX}" == "/usr/local" && ! "${PREFIX}" =~ ^"/opt" ]]; then
  echo "ERROR:  PREFIX set to '${PREFIX}'. Must either be '/usr/local' or within '/opt'."
  exit 1
fi

# Download and extract source code
cd /tmp
wget https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz || \
  wget https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz
tar zxf R-${R_VERSION}.tar.gz --no-same-owner
cd R-${R_VERSION}

# Apply patches
mv /tmp/*.patch .
if [[ -f "${R_VERSION}.patch" ]]; then
  patch -p0 <${R_VERSION}.patch
fi
# According to https://www.debian.org/doc/debian-policy/ch-opersys.html#site-specific-programs
if [[ "${PREFIX}" == "/usr/local" && -e /tmp/etc/staff-group-for-usr-local ]]; then
  sed -i 's|dirmode=$|dirmode=2775|g' src/scripts/mkinstalldirs.in
  sed -i 's|echo "mkdir -m $dirmode -p -- $\*"|echo "mkdir -m $dirmode -p $\*"|g' src/scripts/mkinstalldirs.in
  sed -i 's|exec mkdir -m "$dirmode" -p -- "$@"|mkdir -m "$dirmode" -p "$@"\n      echo "chown root:staff $*"\n      chown root:staff "$@"|g' src/scripts/mkinstalldirs.in
fi

# Build and install
R_PAPERSIZE=letter \
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
  ./configure ${CONFIG_ARGS} --prefix=${PREFIX}

if [[ "${MODE}" =~ ^"install" ]]; then
  make
  make ${MODE}
  if [[ "${MODE}" == "install-strip" ]]; then
    echo "_R_SHLIB_STRIP_=true" >> ${PREFIX}/lib/R/etc/Renviron.site
  fi
else
  if [[ "${MODE}" == "uninstall" && -e ${PREFIX}/lib/R/etc/Renviron.site ]]; then
      rm -f ${PREFIX}/lib/R/etc/Renviron.site
  fi
  make ${MODE}
fi
