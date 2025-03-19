# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit cmake-multilib distutils-r1

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="https://github.com/andreasvc/pyre2/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/pyre2.git"
	EGIT_BRANCH="py-cleanup"
	inherit git-r3
else
	SRC_URI="https://github.com/andreasvc/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="
	dev-libs/re2:=
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS README.rst CHANGELOG.rst )

RESTRICT="!test? ( test )"
# FIXME figure out who is stripping
QA_PRESTRIPPED="usr/lib/*/site-packages/re2.*.so"

distutils_enable_tests unittest

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	cmake_src_prepare
	distutils-r1_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DSCM_VERSION_INFO="${SETUPTOOLS_SCM_PRETEND_VERSION}"
	)
	cmake_src_configure
}

src_configure() {
	cmake-multilib_src_configure
	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_test() {
	distutils-r1_src_test
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	distutils-r1_src_install
}
