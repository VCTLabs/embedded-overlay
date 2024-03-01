# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Convert between XML files and YAML files (or sort some YAML)."
HOMEPAGE="
	https://sarnold.github.io/ymltoxml/
	https://github.com/sarnold/ymltoxml
"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/ymltoxml.git"
	EGIT_BRANCH="main"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/ymltoxml/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
RESTRICT="test"  # no tests :(
IUSE="doc"

RDEPEND="
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
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
