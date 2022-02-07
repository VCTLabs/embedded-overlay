# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="UserspaceIO helper library"
HOMEPAGE="https://github.com/missinglinkelectronics/libuio"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/missinglinkelectronics/libuio.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/missinglinkelectronics/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

SLOT="0"
LICENSE="GPL-2"

IUSE="doc nls static-libs"

RDEPEND="virtual/libiconv
	sys-devel/gettext
	dev-libs/glib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"

DOCS=( README )

RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}
