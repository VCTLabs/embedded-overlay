# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="The google styleguide together with cpplint (GH version)"
HOMEPAGE="https://github.com/cpplint/cpplint"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/cpplint/cpplint.git"
	EGIT_BRANCH="develop"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/cpplint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="CC-BY-3.0"
SLOT="0"
IUSE=""

RESTRICT=

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( README.rst CONTRIBUTING.rst )

python_prepare_all() {
	sed -i '/pytest-runner/d' setup.py

	distutils-r1_python_prepare_all
}
