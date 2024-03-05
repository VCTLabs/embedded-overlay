# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYPI_PN="forwarder"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )
MY_P="${PYPI_PN}-${PV}"

inherit distutils-r1

DESCRIPTION="A python raw socket proxy with optional SSL/TLS termination"
HOMEPAGE="https://github.com/pe2mbs/pyforwarder/wiki"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/pe2mbs/pyforwarder.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${MY_P}"
	inherit pypi
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="test"
