# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit eutils flag-o-matic llvm python-single-r1

DESCRIPTION="Yosys - Yosys Open SYnthesis Suite"
HOMEPAGE="http://www.clifford.at/yosys/"
LICENSE="ISC"
SRC_URI="https://github.com/YosysHQ/${PN}/archive/${P}.tar.gz"

SLOT="0"
# this should be fine on arm, except... boost deps
# please test on appropriate arm hardware specs, eg, RAM, I/O, storage
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+abc clang extended-test test"

RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	$(python_gen_cond_dep 'dev-libs/boost:=[context,python,threads(+),${PYTHON_USEDEP}]')
	media-gfx/graphviz:=[python,svg,tcl]
	sys-libs/readline:=
	dev-libs/libffi
	dev-vcs/git
	dev-lang/tcl:=
	${PYTHON_DEPS}
	abc? ( dev-embedded/abc )
	test? ( sci-electronics/iverilog )
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-apps/gawk
	virtual/pkgconfig
"

RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
"

S="${WORKDIR}/${PN}-${P}"

python_check_deps() {
	has_version "dev-libs/boost:=[context,python,threads(+),${PYTHON_USEDEP}]"
}

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_configure() {
	local configcc="config-gcc"
	use clang && configcc="config-clang"

	emake $configcc
	echo "ENABLE_ABC := $(usex abc 1 0)" >> "${S}/Makefile.conf"
	use abc && echo "ABCEXTERNAL := abc" >> "${S}/Makefile.conf"
}

src_compile() {
	strip-unsupported-flags  # some tests will die
	if use clang && ! tc-is-clang ; then
		einfo "Enforcing the use of clang due to USE=clang ..."
		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
		replace-flags -ftree-vectorize -fvectorize
		replace-flags -flto* -flto=thin
		filter-flags -Wl,--as-needed -Wl,-O*
	elif ! use clang && ! tc-is-gcc ; then
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		export CC=${CHOST}-gcc
		export CXX=${CHOST}-g++
	fi

	export LD="${CC}"
	emake PREFIX="${EPREFIX}/usr"
}

src_test() {
	tc-export CC CXX
	export LD="${CC}"
	if ! use extended-test; then
		pushd "${S}"/tests/simple > /dev/null
			./run-test.sh
		popd > /dev/null
	else
		emake test
	fi
}

src_install() {
	emake STRIP="true" PREFIX="${ED}/usr" install
}
