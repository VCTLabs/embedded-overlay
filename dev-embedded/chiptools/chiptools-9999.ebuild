# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..13} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="ChipTools is a utility to automate FPGA build and verification"
HOMEPAGE="https://github.com/sarnold/chiptools"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/${PN}.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-electronics/ghdl
	sci-electronics/iverilog
"

DEPEND="${RDEPEND}"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/versioningit[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}] )
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-apidoc[${PYTHON_USEDEP}] )
"

DOCS=( README.md )

RESTRICT="!test? ( test )"

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_test() {
	pytest chiptools --doctest-modules tests/ \
		|| die "Tests fail with ${EPYTHON}"
}
