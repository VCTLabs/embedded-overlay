# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Adds support for tests during installation of setup.py files"
HOMEPAGE="https://pypi.org/project/pytest-runner/ https://github.com/pytest-dev/pytest-runner"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/jaraco-packaging \
	dev-python/rst-linker

distutils_enable_tests pytest

# Tests require network access and unpackaged deps
# TODO unbreak tests
RESTRICT="test"
