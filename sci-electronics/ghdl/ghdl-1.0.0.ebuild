# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Figure out how to test all this and maybe support other versions
ADA_COMPAT=( gnat_2019 )
inherit ada llvm

DESCRIPTION="The GHDL VHDL simulator."
HOMEPAGE="http://ghdl.free.fr/"
SRC_URI="https://github.com/ghdl/ghdl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=11

RDEPEND="${ADA_DEPS}
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest
		dev-python/decor
		>=sci-electronics/pyVHDLModel-0.8.0
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
	local llvm_config="$(get_llvm_prefix "$LLVM_MAX_SLOT")/bin/llvm-config"
	econf --with-llvm-config=${llvm_config}
}

src_test() {
	GHDL_PREFIX="${S}/ghdl" default
}

src_install() {
	default
	rmdir "${ED}"/usr/ghdl
}
