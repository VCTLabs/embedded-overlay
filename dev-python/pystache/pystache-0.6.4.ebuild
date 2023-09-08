# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python implementation of Mustache templating framework."
HOMEPAGE="https://github.com/PennyDreadfulMTG/pystache"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/PennyDreadfulMTG/pystache.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/PennyDreadfulMTG/pystache/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/iniconfig[${PYTHON_USEDEP}]
	)
"

RESTRICT="!test? ( test )"

distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules \
		--doctest-glob='*.rst' \
		--doctest-glob='*.py' \
		.
}

src_prepare() {
	sed -i '/sphinx_git/d' "${S}"/setup.cfg "${S}"/docs/source/conf.py
	default
}
