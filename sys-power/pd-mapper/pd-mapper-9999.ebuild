# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Qualcomm Protection Domain mapper."
HOMEPAGE="https://github.com/andersson/pd-mapper"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andersson/pd-mapper.git"
else
	SRC_URI="https://github.com/andersson/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
fi

SLOT="0"
LICENSE="BSD"
IUSE=""

BDEPEND="sys-power/qrtr"

src_prepare() {
	sed -i -e "s|fix)/lib|fix)/$(get_libdir)|g" "${S}"/Makefile

	default
}

src_compile() {
	emake CC=$(tc-getCC) prefix="${EPREFIX}/usr" || die "make failed..."
}

src_install() {
	emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install || die "make install failed..."

	newinitd "${FILESDIR}/${PN}".init "${PN}"
}
