# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Reuse virtualenvs with multiple tox test environments"
HOMEPAGE="
	https://pypi.org/project/tox-ignore-env-name-mismatch/
	https://github.com/masenf/tox-ignore-env-name-mismatch/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/tox-4.0[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
"
# setuptools_scm_git_archive is not actually needed here
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
