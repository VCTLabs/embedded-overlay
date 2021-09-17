# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="High-level, multiplatform C++ network packet sniffing and crafting library."
HOMEPAGE="https://libtins.github.io/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/mfontanini/libtins.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/mfontanini/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="+cxx11 +ack-tracker +wpa2 +dot11 +static-libs"

REQUIRED_USE="
	wpa2? ( dot11 )
"

DEPEND="
	ack-tracker? ( dev-libs/boost:0[${MULTILIB_USEDEP}] )
	wpa2? ( dev-libs/openssl:0[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	net-libs/libpcap[${MULTILIB_USEDEP}]
"

RESTRICT="mirror"

PATCHES=( "${FILESDIR}/${PN}-3.4-multilib-hack.patch" )

src_prepare() {
	cmake_src_prepare
	sed -i '/CMAKE_INSTALL_LIBDIR lib/d' CMakeLists.txt  || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DLIBTINS_ENABLE_CXX11="$(usex cxx11)"
		-DLIBTINS_ENABLE_ACK_TRACKER="$(usex ack-tracker)"
		-DLIBTINS_ENABLE_WPA2="$(usex wpa2)"
		-DLIBTINS_ENABLE_DOT11="$(usex dot11)"
		-DLIBTINS_BUILD_SHARED="$(usex !static-libs)"
	)

	cmake_src_configure
}