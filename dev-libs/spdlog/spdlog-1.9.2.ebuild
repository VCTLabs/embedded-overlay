# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/${PN}"
else
	SRC_URI="https://github.com/gabime/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="MIT"
SLOT="0/1"
IUSE="+ho test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/libfmt-8.0.1:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	rm -r include/spdlog/fmt/bundled || die "Failed to delete bundled libfmt"
}

src_configure() {
	local mycmakeargs=(
		-DSPDLOG_BUILD_BENCH=no
		-DSPDLOG_BUILD_EXAMPLE=no
		-DSPDLOG_BUILD_SHARED=yes
		-DSPDLOG_BUILD_TESTS=$(usex test)
	)

	local fmtho="-DSPDLOG_FMT_EXTERNAL=yes"
	if use ho; then
		fmtho="-DSPDLOG_FMT_EXTERNAL_HO=yes"
	fi

	mycmakeargs+=( $fmtho )

	cmake_src_configure
}
