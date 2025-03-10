# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_VALID_SLOTS=( 17 )
LLVM_MAX_SLOT="${LLVM_VALID_SLOTS[0]}"

ADA_COMPAT=( gnat_2021 gcc_12 )
# should have gcc_12_2_0
inherit ada llvm

DESCRIPTION="The GHDL VHDL simulator."
HOMEPAGE="http://ghdl.free.fr/"
SRC_URI="https://github.com/ghdl/ghdl/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="${ADA_DEPS}
	<llvm-core/llvm-$((${LLVM_MAX_SLOT} + 1)):=
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest
		dev-python/decor
		<=sci-electronics/pyVHDLModel-0.10.5
	)
"

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/ghdl_1.0.0_configuration.patch
)

pkg_setup() {
	ada_pkg_setup
	llvm_pkg_setup
	local llvm_config="$(get_llvm_prefix "$LLVM_MAX_SLOT")/bin/llvm-config"
}

src_configure() {
	# shorten test suite for default tests
	sed -i "s|suite.sh|suite.sh sanity pyunit vpi|g" Makefile.in || die

	local llvm_config="$(get_llvm_prefix "$LLVM_MAX_SLOT")/bin/llvm-config"
	econf --with-llvm-config=${llvm_config}
}

src_test() {
	# tests use gcc from gnat, so are sensitive to user FLAGS for
	# newer toolchains. also the full testsuite is much too big...
	local -x CFLAGS= CXXFLAGS= LDFLAGS=
	GHDL_PREFIX="${S}/ghdl" default
}

src_install() {
	default
	rmdir "${ED}"/usr/ghdl
}
