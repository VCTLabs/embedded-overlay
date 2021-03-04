# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1 cmake

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sarnold/datrie.git"
	EGIT_BRANCH="master"
	SRC_URI=""
	KEYWORDS=""
else
	MY_PV="${PV/_p/-}"
	SRC_URI="https://github.com/freepn/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Fast, efficiently stored Trie for Python. Uses libdatrie."
HOMEPAGE="https://github.com/pytries/datrie"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libdatrie:="

DEPEND="${RDEPEND}"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.57.1[${PYTHON_USEDEP}] )
"

src_configure() {
	python_setup
	cmake_src_configure
	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}

python_test() {
	pytest -v
}

src_test() {
	python_test
}
