# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_p/-}"
MY_P="${PN}-${MY_PV}"

CMAKE_MAKEFILE_GENERATOR="ninja"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 cmake

DESCRIPTION="RE2 Python bindings from google"
HOMEPAGE="https://github.com/sarnold/google-re2"

SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"

RDEPEND="dev-libs/re2:="
DEPEND="${RDEPEND}"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/absl-py[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

src_prepare() {
	eapply "${FILESDIR}/${PN}-partial-packaging-updates.patch"
	distutils-r1_src_prepare
	export SETUPTOOLS_SCM_PRETEND_VERSION="${MY_PV}"
	cmake_src_prepare
}

src_configure() {
	distutils-r1_src_configure
	local mycmakeargs=(
		-DSCM_VERSION_INFO="${SETUPTOOLS_SCM_PRETEND_VERSION}"
	)

	cmake_src_configure
}

src_install() {
	distutils-r1_src_install
	python_foreach_impl python_domodule re2.py "${BUILD_DIR}"/*.so
}

python_test() {
	distutils_install_for_testing
	cd "${T}" || die
	epytest "${S}"
}

src_test() {
	distutils-r1_src_test
}
