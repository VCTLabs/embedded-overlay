# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="view/edit binary with any text editor"
HOMEPAGE="https://github.com/sarnold/hexdump"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/hexdump.git"
	EGIT_BRANCH="main"
	inherit git-r3
else
	MY_PV="${PV/_p/-}"
	SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="AGPL-3"
SLOT="0"

python_test() {
	"${EPYTHON}" "${S}"/src/hexdump/hexdump.py --test \
		|| die "Testing failed with ${EPYTHON}"
}
