# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Configures the composite video output of some Allwinner-based embedded boards"
HOMEPAGE="https://projects.nwrk.biz/projects/allwinner-tvout"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/VCTLabs/allwinner-tvout.git"
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm ~arm64"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""

PATCHES=( "${FILESDIR}/${P}-makefile-install.patch" )

src_compile() {
	emake CC=$(tc-getCC) -C src release || die "make failed..."
}

src_install() {
	 emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" -C src install \
		|| die "make install failed..."
}
