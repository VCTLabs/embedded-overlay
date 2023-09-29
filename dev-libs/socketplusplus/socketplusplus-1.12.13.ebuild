# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION=""
HOMEPAGE="https://github.com/malaterre/socketxx-1"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://salsa.debian.org/med-team/socketplusplus.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://salsa.debian.org/med-team/${PN}/-/archive/master/socketplusplus-master.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
	S="${WORKDIR}/${PN}-master"
fi

SLOT="0"
LICENSE="MIT"
IUSE="doc static-libs"

BDEPEND="doc? ( sys-apps/texinfo )"

DOCS=( README README2 README3 )

PATCHES=(
	"${FILESDIR}/${P}-sys_errlist.patch"
	"${FILESDIR}/${P}-glibc-2.32.patch"
	"${FILESDIR}/${P}-configure-in-fix.patch"
)

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

src_compile() {
	emake all
	use doc && emake -C doc
}
