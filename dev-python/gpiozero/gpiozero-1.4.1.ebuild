# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A simple interface to GPIO devices with Raspberry Pi"
HOMEPAGE="https://github.com/RPi-Distro/python-gpiozero"
SRC_URI="https://github.com/RPi-Distro/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
