# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#CMAKE_IN_SOURCE_BUILD="true"
CMAKE_VERBOSE=ON

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='threads(+)'

inherit cmake python-r1 toolchain-funcs

DESCRIPTION="Library for low speed IO in C with bindings for C++, Python, Node.js & Java"
HOMEPAGE="https://github.com/intel-iot-devkit/mraa"

SRC_URI="https://github.com/intel-iot-devkit/mraa/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc examples java tools"

COMMON_DEPS="${PYTHON_DEPS}
	doc? ( dev-python/sphinx )
	java? ( virtual/jdk:= )
	dev-libs/json-c
	virtual/libudev"

## FIXME
# node? ( <net-libs/nodejs-7 )
# -DBUILDSWIGNODE="$(usex node)"
# nodejs wrappers need older nodejs version and ~amd64 keyword
# look for upstream patches
# (note this ebuild is mainly for the python wrappers, others not tested)

DEPEND="${COMMON_DEPS}
	dev-lang/swig
	dev-cpp/gtest"

RDEPEND="${COMMON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/mraa-${PV}"

RESTRICT="test"

PATCHES=( "${FILESDIR}/${PV}" )

# disabling onewire causes link failures: undefined reference to `mraa_uart_ow_init'
src_configure() {
	tc-export CC CXX AR RANLIB PKG_CONFIG
	PKG_CONFIG_LIBDIR="${EPREFIX}/usr/$(get_libdir)/pkgconfig"

	python_setup

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}/usr"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_SKIP_INSTALL_RPATH=ON
		-DCMAKE_SKIP_RPATH=ON
		-DBUILDCPP=ON
		-DBUILDSWIG=ON
		-DBUILDSWIGNODE=OFF
		-DBUILDSWIGPYTHON=ON
		-DBUILDDOC="$(usex doc)"
		-DBUILDSWIGJAVA="$(usex java)"
		-DINSTALLTOOLS="$(usex tools)"
		-DENABLEEXAMPLES="$(usex examples)"
		-DFIRMATA=ON
		-DUSBPLAT=ON
		-DONEWIRE=ON
		-DJSONPLAT=ON
		-DFTDI4222=OFF
		-DIMRAA=ON
		-DBUILDTESTS=OFF
	)

	export GMOCK_PREFIX="${EPREFIX}/usr"

	cmake_src_configure
}
