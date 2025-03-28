# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

PDFS_COMMIT=d646009a0e3e71daf13a52ab1029e2230920ebf4
DESCRIPTION="PDF file reader/writer library"
HOMEPAGE="https://github.com/sarnold/pdfrw"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/pdfrw.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV="${PV/_p/-}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.gh.tar.gz
		test? ( https://github.com/pmaupin/static_pdfs/archive/${PDFS_COMMIT}.tar.gz
			-> pdfrw-static_pdfs-${PDFS_COMMIT}.gh.tar.gz )"
	KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 sparc x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD MIT"
SLOT="0"
IUSE="crypt test"

BDEPEND="dev-python/pillow[${PYTHON_USEDEP}]
	crypt? ( dev-python/pycryptodome[${PYTHON_USEDEP}] )
	test? ( dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

# unittest would be sufficient but its output is unreadable
distutils_enable_tests pytest

src_unpack() {
	default
	if use test; then
		mv "static_pdfs-${PDFS_COMMIT}"/* "${MY_P}"/tests/static_pdfs || die
	fi
}

python_test() {
	# speed tests up
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p xdist.plugin -n "$(makeopts_jobs)" . || die
}
