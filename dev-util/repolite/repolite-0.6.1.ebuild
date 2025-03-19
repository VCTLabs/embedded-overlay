# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature

DESCRIPTION="Manage a small set of git repository dependencies with YAML."
HOMEPAGE="https://github.com/sarnold/repolite"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/repolite.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/repolite/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"
RESTRICT="test"  # no tests :(

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
	dev-vcs/git
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

distutils_enable_sphinx \
	docs/source \
	dev-python/sphinx-rtd-theme \
	dev-python/recommonmark \
	dev-python/sphinxcontrib-apidoc

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	sed -i '/sphinx_git/d' "${S}"/setup.cfg "${S}"/docs/source/conf.py
	default
}

pkg_postinst() {
	optfeature "initialize repos with lfs files" dev-vcs/git-lfs
}
