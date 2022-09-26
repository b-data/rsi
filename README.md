[![minimal-readme compliant](https://img.shields.io/badge/readme%20style-minimal-brightgreen.svg)](https://github.com/RichardLitt/standard-readme/blob/master/example-readmes/minimal-readme.md) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) <a href="https://liberapay.com/benz0li/donate"><img src="https://liberapay.com/assets/widgets/donate.svg" alt="Donate using Liberapay" height="20"></a> <a href="https://benz0li.b-data.io/donate?project=4"><img src="https://benz0li.b-data.io/donate/static/donate-with-fosspay.png" alt="Donate with fosspay"></a>

# Containerised R source-installation

[This project](https://gitlab.com/b-data/r/rsi) is intended for system
administrators who want to perform a source-installation of R. It is meant for
installing
[official releases of R source code](https://cran.r-project.org/src/base/)
on Debian-based Linux distributions, e.g. Ubuntu, using a docker container.

## Table of Contents

*  [Prerequisites](#prerequisites)
*  [Install](#install)
*  [Usage](#usage)
*  [References](#references)
*  [Contributing](#contributing)
*  [License](#license)

## Prerequisites

This projects requires an installation of docker and docker compose.

### Docker

To install docker, follow the instructions for your platform:

*  [Install Docker Engine | Docker Documentation > Supported platforms](https://docs.docker.com/engine/install/#supported-platforms)
*  [Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/engine/install/linux-postinstall/)

### Docker Compose

*  [Install Docker Compose | Docker Documentation](https://docs.docker.com/compose/install/)

### Debian Packages

To cover the runtime dependencies on a **headless server**, the latest version of
`r-base-dev` (currently 4.2.1) requires the following packages:

*  `build-essential`
*  `ca-certificates`
*  `g++`
*  `gfortran`
*  `libbz2-dev`
*  `'^libcurl[3|4]$'`
*  `libicu-dev`
*  `'^libjpeg.*-turbo.*-dev$'`
*  `liblzma-dev`
*  `${BLAS}`
*  `libpangocairo-1.0-0`
*  `libpaper-utils`
*  `'^libpcre[2|3]-dev$'`
*  `libpng-dev`
*  `libreadline-dev`
*  `libtiff5`
*  `pkg-config`
*  `unzip`
*  `zip`
*  `zlib1g`

These packages must be available on the host. Replace `${BLAS}` with the
\[LAPACK/\]BLAS library set in `.env` (default: `liblapack-dev` which depends on
`libblas-dev`).

#### Tcl/Tk and X11 capabilities

Install the following package dependencies for `r-base-dev` to gain Tcl/Tk and
X11 capabilities at runtime:

*  `libtcl8.6`
*  `libtk8.6`
*  `libxss1`
*  `libxt6`
*  `xauth`
*  `xdg-utils`

## Install

Clone the source code of this project:

```bash
git clone https://gitlab.com/b-data/r/rsi.git
```

## Usage

Change directory and make a copy of all `sample.` files:

```bash
cd rsi
git checkout main

for file in sample.*; do cp "$file" "${file#sample.}"; done;
```

In `.env`, set `IMAGE` according to the host's Debian-based Linux distribution
(`<distribution>:<release>`), `R_VERSION` to the desired version of R
(`<major>.<minor>.<patch>`) and `PREFIX` to the location, where you want the
R programs to be installed (default: `/opt/local`).

If you intend to install multiple versions of R, set `SUBDIR` to automatically
create separate subdirectories for each version (e.g. `/R/${R_VERSION}`).

Then, create and start container _rsi_ using options `--build` (_Build images
before starting containers_) and `-V` (_Recreate anonymous volumes instead of
retrieving data from the previous containers_):

```bash
docker-compose up --build -V
```

Do not forget to add `PREFIX[/SUBDIR]/bin` to `PATH` when using a `PREFIX`
within `/opt`.

## References

*  [18326 – Compilation with gcc on aarch64 requires -fPIC for large packages](https://bugs.r-project.org/show_bug.cgi?id=18326)
    *  [[R] Package installation on aarch64 fails for v0.3.2 · Issue #3049 · duckdb/duckdb](https://github.com/duckdb/duckdb/issues/3049)
    *  [[R] Package installation on aarch64 fails · Issue #3213 · mlpack/mlpack](https://github.com/mlpack/mlpack/issues/3213)
*  [Bug#982069: /usr/local/lib/R owned by group staff even if /etc/staff-group-for-usr-local not present](https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1790651.html)
    *  [9. The Operating System — Debian Policy Manual > ... > 9.1.2. Site-specific programs](https://www.debian.org/doc/debian-policy/ch-opersys.html#site-specific-programs)
    *  [Filesystem Hierarchy Standard > ... > 4.9. /usr/local : Local hierarchy](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04s09.html)

## Contributing

PRs accepted.

This project follows the
[Contributor Covenant](https://www.contributor-covenant.org)
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE) © 2021 b-data GmbH
