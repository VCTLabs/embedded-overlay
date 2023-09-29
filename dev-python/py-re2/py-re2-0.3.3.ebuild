# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 cmake

MY_PV="${PV/_p/-}"
MY_PN="pyre2"

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="https://github.com/andreasvc/pyre2/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/${MY_PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/andreasvc/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/re2:="
DEPEND="${RDEPEND}"

BDEPEND=">=dev-util/cmake-3.15
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}] )
"

DOCS=( AUTHORS README.rst CHANGELOG.rst )

RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

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
	# Run doc tests first, needs extension
	nosetests -sx tests/re2_test.py || die "doc tests failed with ${EPYTHON}"
	nosetests -sx tests/test_re.py || die "tests failed with ${EPYTHON}"
}

src_test() {
	python_test
}
