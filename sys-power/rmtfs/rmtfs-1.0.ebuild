# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="Qualcomm Remote Filesystem Service Implementation"
HOMEPAGE="https://github.com/andersson/rmtfs"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andersson/rmtfs.git"
else
	SRC_URI="https://github.com/andersson/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
fi

SLOT="0"
LICENSE="BSD"
IUSE=""

BDEPEND="sys-power/qmic"

DEPEND="sys-power/qrtr
	kernel_linux? ( virtual/udev )
"

src_prepare() {
	sed -i -e "s|fix)/lib|fix)/$(get_libdir)|" "${S}"/Makefile

	default
}

src_compile() {
	emake CC=$(tc-getCC) prefix="${EPREFIX}/usr" || die "make failed..."
}

src_install() {
	emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install || die "make install failed..."

	use kernel_linux && udev_newrules "${FILESDIR}/${PN}".rules 65-${PN}.rules
	newinitd "${FILESDIR}/${PN}".init "${PN}"
}

pkg_postinst() {
	use kernel_linux && udev_reload
}

pkg_postrm() {
	use kernel_linux && udev_reload
}
