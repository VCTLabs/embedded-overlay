# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
PYPI_PN="py${PN}"

inherit distutils-r1 pypi

DESCRIPTION="Easy-peasy Python decorators"
HOMEPAGE="https://github.com/mplanchard/pydecor"

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
