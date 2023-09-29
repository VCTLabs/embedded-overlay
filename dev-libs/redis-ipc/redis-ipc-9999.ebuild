# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A client library for using redis as IPC msg/event bus."
HOMEPAGE="https://github.com/VCTLabs/redis-ipc"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/redis-ipc.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE="+pic static-libs"

DEPEND="dev-libs/hiredis:=
	dev-libs/json-c"

RDEPEND="${DEPEND}
	dev-db/redis"

DOCS=( README.rst )

# tests require a running redis server
RESTRICT="test"

src_prepare() {
	sed -i -e "s|/lib|/$(get_libdir)|" "${S}"/redis-ipc.pc.in || die

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with pic)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}
