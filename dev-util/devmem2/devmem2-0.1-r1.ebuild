# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple program to read/write from/to any location in memory."
HOMEPAGE="https://github.com/VCTLabs/devmem2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/VCTLabs/devmem2.git"
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm ~arm64 ~mips ~ppc ~riscv"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-cleanup-address-sizing-allow-strict-alignment.patch"
	"${FILESDIR}/${P}-ensure-word-is-32-bit-add-64-bit-support.patch"
)

src_compile() {
	emake CC=$(tc-getCC) || die "make failed..."
}
