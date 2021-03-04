# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 git-r3

DESCRIPTION="RE2 Python bindings from google"
HOMEPAGE="https://github.com/freepn/google-re2"
EGIT_REPO_URI="https://github.com/freepn/google-re2.git"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/google-re2.git"
	EGIT_BRANCH="main"
	KEYWORDS=""
else
	EGIT_COMMIT="${PV/_p/-}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="
	dev-util/cmake
	dev-util/ninja
	dev-libs/re2
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/absl-py[${PYTHON_USEDEP}] )
"

RESTRICT="!test? ( test )"

distutils_enable_tests pytest
