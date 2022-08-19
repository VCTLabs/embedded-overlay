# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Python implementation of Mustache"
HOMEPAGE="https://github.com/sarnold/pystache"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/pystache.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

BDEPEND="${RDEPEND}
	test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
"

RESTRICT="!test? ( test )"

python_test() {
	distutils_install_for_testing
	pystache-test . || die "Test failed with ${EPYTHON}"
}
