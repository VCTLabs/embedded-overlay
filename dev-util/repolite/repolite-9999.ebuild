# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Manage a small set of repository dependencies without git submodules."
HOMEPAGE="https://github.com/sarnold/repolite"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/repolite.git"
	#EGIT_BRANCH="main"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc"
RESTRICT="test"

BDEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/versioningit[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

RESTRICT="test"

distutils_enable_sphinx \
        docs/source \
        dev-python/sphinx_rtd_theme \
        dev-python/recommonmark \
        dev-python/sphinxcontrib-apidoc
