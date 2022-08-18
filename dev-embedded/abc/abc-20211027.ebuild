# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

# sadly no upstream tags or releases from gh
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/${PN}.git"
	EGIT_BRANCH="master"
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
IUSE="+cpp debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/readline:=
	sys-libs/ncurses:=
"

RDEPEND="${DEPEND}
	sci-visualization/gnuplot
	media-gfx/graphviz
	app-text/gv
"

src_compile() {
	tc-export CC CXX AR LD
	append-flags -Wno-deprecated
	local myopts

	use debug || myopts+=" OPTFLAGS="

	if use cpp; then
		myopts+=" ABC_USE_NAMESPACE=xxx"
	else
		myopts+=" ABC_USE_STDINT_H=1"
	fi

	ABC_MAKE_VERBOSE=1 emake ${myopts} ABC_USE_PIC=1 abc
	use static-libs && emake ${myopts} ABC_USE_PIC=1 libabc.a
}

src_install() {
	dobin abc
	dolib.so libabc.so*
	use static-libs && dolib.a libabc.a

	einfo "Installing base headers required for abc"
	local header
	pushd "${S}"/src/base > /dev/null
		find . -name '*.h' | \
		while read header ; do
			mkdir -p "${ED}/usr/include/abc/$(dirname ${header})" || die
			cp ${header} "${ED}/usr/include/abc/$(dirname ${header})" || die
		done
	popd > /dev/null
}

src_test() {
	tc-export CC CXX AR LD
	local myopts

	use debug || myopts+=" OPTFLAGS="

	if use cpp; then
		myopts+=" ABC_USE_NAMESPACE=xxx"
	else
		myopts+=" ABC_USE_STDINT_H=1"
	fi

	ABC_MAKE_VERBOSE=1 emake ${myopts} ABC_USE_PIC=1 test
}
