# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="forwarder"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python raw socket proxy with optional SSL/TLS termination"
HOMEPAGE="https://github.com/pe2mbs/pyforwarder/wiki"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/pe2mbs/pyforwarder.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="test"
