# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freepn/sarnold.git"
	EGIT_BRANCH="master"
	SRC_URI=""
else
	MY_PV="${PV/_p/-}"
	SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Fast, efficiently stored Trie for Python. Uses libdatrie."
HOMEPAGE="https://github.com/pytries/datrie"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-libs/libdatrie:=
"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/cython-0.20[${PYTHON_USEDEP}]' 'python*')
	test? ( >=dev-python/hypothesis-4.57.1[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
