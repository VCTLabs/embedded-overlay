# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Userspace reference for net/qrtr in the Linux kernel."
HOMEPAGE="https://github.com/andersson/qmic"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andersson/qmic.git"
else
	SRC_URI="https://github.com/andersson/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
fi

SLOT="0"
LICENSE="BSD"
IUSE=""

DEPEND=""

src_compile() {
	emake CC=$(tc-getCC) prefix="${EPREFIX}/usr" || die "make failed..."
}

src_install() {
	emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install || die "make install failed..."
}
