# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="ESP8266 ROM Bootloader utility"
HOMEPAGE="https://pypi.python.org/pypi/esptool"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	dev-python/pyserial
	"
