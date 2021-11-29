# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_VERBOSE=ON
LLVM_VALID_SLOTS=( 12 11 10 )
LLVM_MAX_SLOT="${LLVM_VALID_SLOTS[0]}"

inherit cmake flag-o-matic llvm toolchain-funcs

# sadly no upstream tags or releases from gh
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/${PN}.git"
	EGIT_BRANCH="codeql"
	#EGIT_COMMIT="e1269f78473a8fd0bf1aefe032f2c9637f2ec97b"
	inherit git-r3
else
	GIT_COMMIT="d13e33cdd8451ad4ecfcb9093fbaa628f0e6659d"
	SRC_URI="https://github.com/berkeley-abc/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}"/${PN}-${GIT_COMMIT}
	PATCHES=(
		"${FILESDIR}/${P}-cleanup-makefile-add-shared-libs.patch"
		"${FILESDIR}/${P}-add-missing-gia-c-to-module-make.patch"
		"${FILESDIR}/${P}-post-ci-makefile-fix.patch"
		"${FILESDIR}/${P}-fix-build-with-clang.patch"
	)
fi

DESCRIPTION="A system for sequential logic synthesis and formal verification"
HOMEPAGE="https://people.eecs.berkeley.edu/~alanmi/abc/"

LICENSE="MIT"
SLOT="0"
IUSE="clang +cpp debug lto test +tools"
RESTRICT="!test? ( test )"

LLVM_DEPEND="
	<sys-devel/llvm-$(( LLVM_MAX_SLOT + 1 )):=
	lto? ( sys-devel/lld )
"

DEPEND="
	clang? ( ${LLVM_DEPEND} )
	sys-libs/readline:=
	sys-libs/ncurses:=
"

BDEPEND="
	clang? ( >=sys-devel/clang-3.5 )
	!clang? ( >=sys-devel/gcc-4.7 )
"

RDEPEND="${DEPEND}
	sci-visualization/gnuplot
	media-gfx/graphviz
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
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	local mycmakeargs=(
		-DABC_USE_NAMESPACE=$(usex cpp xxx)
		-DBUILD_TESTING=$(usex test)
		-DABC_SKIP_EXE=$(usex !tools)
		-DABC_ENABLE_LTO=$(usex lto)
		-DBUILD_SHARED_LIBS=ON
	)

	cmake_src_configure
}

src_test() {
	local TEST_VERBOSE=1
	cmake_src_test
}
