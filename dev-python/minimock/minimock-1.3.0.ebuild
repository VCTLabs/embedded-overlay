# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="The simplest possible mock library"
HOMEPAGE="https://github.com/lowks/minimock"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/lowks/minimock.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/lowks/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

DOCS=( README.rst CHANGELOG.txt )

distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules .
}
