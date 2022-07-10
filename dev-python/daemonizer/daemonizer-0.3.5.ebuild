# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python daemonizer for Unix, Linux and OS X"
HOMEPAGE="https://sarnold.github.io/python-daemonizer/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/python-${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/python-${PN}/releases/download/${PV}/${P}.tar.gz"
	#SRC_URI="https://github.com/sarnold/python-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="CC-BY-SA-3.0"
SLOT="0"

# optional rdeps include gevent and eventlet. they may or may not still be
# useful/working; interfaces have been updated but are still untested.
BDEPEND="${PYTHON_DEPS}
	dev-python/versioningit[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx \
	docs/source \
	dev-python/sphinx_rtd_theme \
	dev-python/recommonmark \
	dev-python/sphinxcontrib-apidoc

python_test() {
	"${EPYTHON}" -m pytest -v test/ || die "Testing failed with ${EPYTHON}"
}
