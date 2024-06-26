# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib multilib-minimal

DESCRIPTION="An implementation for a double-array Trie library in C."
HOMEPAGE="https://linux.thai.net/~thep/datrie/datrie.html"
SRC_URI="https://github.com/tlwg/libdatrie/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="doc graph nls test"

RDEPEND="virtual/libiconv
	sys-devel/gettext"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? (
		graph? ( app-text/doxygen[dot] )
		!graph? ( app-text/doxygen )
	)"

REQUIRED_USE="graph? ( doc )"

PATCHES=( "${FILESDIR}/${P}-fix-configure-ac.patch" )

ECONF_SOURCE=${S}

src_prepare() {
	default

	# elibtoolize
	AT_M4DIR="m4" eautoreconf
}

multilib_src_configure() {
	local myeconfargs

	if use doc; then
		myeconfargs=( --with-html-docdir="${ED}"/usr/share/doc/${PF}/html )
	else
		myeconfargs=( --disable-doxygen-doc )
	fi

	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die
	einstalldocs
}
