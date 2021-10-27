# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

MY_PN="py${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easy-peasy Python decorators"
HOMEPAGE="https://github.com/mplanchard/pydecor"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/dill[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
