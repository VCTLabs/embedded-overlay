# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="MAVLink protocol streams and log files in Python"
HOMEPAGE="https://pypi.org/project/pymavlink/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}] )"

DOCS=( README.md )

#RESTRICT="!test? ( test )"
RESTRICT="test"

python_test() {
	distutils_install_for_testing
	${PYTHON} -m pytest  || die "tests failed under ${EPYTHON}"
}
