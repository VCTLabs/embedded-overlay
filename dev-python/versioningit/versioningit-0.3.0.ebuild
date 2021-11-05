# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS="pyproject.toml"

inherit distutils-r1

DESCRIPTION="yet another setuptools plugin for automatic package versioning"
HOMEPAGE="https://pypi.org/project/versioningit/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-vcs/git
"

distutils_enable_tests pytest

src_prepare() {
	# remove dep on pytest-cov
	sed -i -e '/--cov/d' -e '/--no-cov-on-fail/d' tox.ini || die

	distutils-r1_src_prepare
}

python_test() {
	local ignore=(
		test/test_end2end_hg.py
		test/test_end2end_git.py
		test/test_get_version.py
	)
	epytest ${ignore[@]/#/--ignore }
}
