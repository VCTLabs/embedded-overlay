# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Fork of pyBarcode project"
HOMEPAGE="https://github.com/kxepal/viivakoodi"
SRC_URI="https://github.com/kxepal/viivakoodi/archive/0.8.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
