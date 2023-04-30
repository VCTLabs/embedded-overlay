# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HOMEPAGE="https://github.com/jbagg/QtZeroConf"
DESCRIPTION="Qt wrapper class for ZeroConf libraries across various platforms."

if [[ ${PV} != *9999* ]]; then
	GIT_COMMIT="7b066b1aedc9b70fa8209de4b33649b62f037d2b"
	SRC_URI="https://github.com/jbagg/QtZeroConf/archive/${GIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/QtZeroConf-${GIT_COMMIT}"
else
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
fi

LICENSE="LGPL-3"
SLOT="0/1"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	net-dns/avahi
"
RDEPEND="${DEPEND}"
BDEPEND="net-dns/avahi"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)


	cmake_src_configure
}
