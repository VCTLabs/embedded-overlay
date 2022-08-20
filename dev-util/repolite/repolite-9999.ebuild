# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Manage a small set of repository dependencies without git submodules."
HOMEPAGE="https://github.com/sarnold/repolite"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/repolite.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/repolite/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc lfs"
RESTRICT="test"  # no tests :(

RDEPEND="
	dev-vcs/git
	lfs? ( dev-vcs/git-lfs )
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioningit[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

distutils_enable_sphinx \
	docs/source \
	dev-python/sphinx_rtd_theme \
	dev-python/recommonmark \
	dev-python/sphinxcontrib-apidoc
