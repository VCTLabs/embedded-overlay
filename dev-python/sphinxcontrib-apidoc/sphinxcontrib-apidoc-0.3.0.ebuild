# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A Sphinx extension for running sphinx-apidoc on each build"
HOMEPAGE="https://github.com/sphinx-contrib/apidoc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
"
PDEPEND="
	>=dev-python/sphinx-2.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( ${PDEPEND} )"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinxcontrib-websupport

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
