# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="The simplest possible mock library"
HOMEPAGE="https://github.com/lowks/minimock"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/lowks/minimock.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/lowks/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

LICENSE="MIT"
SLOT="0"
DOCS=( README.rst CHANGELOG.txt )

python_test() {
	"${PYTHON}" -m doctest -v minimock.py || die "Test fail with ${EPYTHON}"
}
