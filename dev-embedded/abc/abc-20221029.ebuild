# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_VERBOSE=ON
LLVM_VALID_SLOTS=( 15 14 13 12 )
LLVM_MAX_SLOT="${LLVM_VALID_SLOTS[0]}"

inherit cmake flag-o-matic llvm toolchain-funcs

# sadly no upstream tags or releases from gh
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/${PN}.git"
	EGIT_BRANCH="squashed"
	inherit git-r3
else
	GIT_COMMIT="93d1c2b38b4d3b371222e56bdcb4d5be45ccb01e"
	SRC_URI="https://github.com/berkeley-abc/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}"/${PN}-${GIT_COMMIT}
fi

DESCRIPTION="A system for sequential logic synthesis and formal verification"
HOMEPAGE="https://people.eecs.berkeley.edu/~alanmi/abc/"

LICENSE="MIT"
SLOT="0"
IUSE="clang +cpp debug lto test +tools"
RESTRICT="!test? ( test )"

LLVM_DEPEND="
	<sys-devel/llvm-$(( LLVM_MAX_SLOT + 1 )):=
	lto? ( <sys-devel/lld-$(( LLVM_MAX_SLOT + 1 )):= )
"

DEPEND="
	clang? ( ${LLVM_DEPEND} )
	sys-libs/readline:=
	sys-libs/ncurses:=
	sys-libs/zlib:=
"

BDEPEND="
	clang? ( >=sys-devel/clang-9.0 )
	!clang? ( >=sys-devel/gcc-8.5.0 )
"

RDEPEND="${DEPEND}
	sci-visualization/gnuplot
	media-gfx/graphviz
	media-libs/libpng
	app-text/gv
"

pkg_setup() {
	use clang && llvm_pkg_setup
}

llvm_check_deps() {
	use clang && has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_configure() {
	if use clang && ! tc-is-clang ; then
		einfo "Enforcing the use of clang due to USE=clang ..."
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
		replace-flags -ftree-vectorize -fvectorize
		if use lto ; then
			replace-flags -flto* -flto=thin
		else
			filter-flags -flto*
		fi
		filter-flags -fgraphite* -floop* -fdevirtualize* -fipa*
		filter-flags -Wl,--as-needed -Wl,-O* -fuse-linker-plugin
	elif ! use clang && ! tc-is-gcc ; then
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DABC_SKIP_EXE=$(usex !tools)
		-DABC_ENABLE_LTO=$(usex lto)
		-DABC_USE_PIC=1
		-DABC_USE_SONAME=1
		-DBUILD_SHARED_LIBS=ON
	)

	if use cpp; then
		mycmakeargs+=( -DABC_USE_NAMESPACE=xxx )
	fi

	cmake_src_configure
}

src_test() {
	local TEST_VERBOSE=1
	cmake_src_test
}
