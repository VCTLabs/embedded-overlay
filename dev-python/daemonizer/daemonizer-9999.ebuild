# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	RESTRICT="test"  # no tests in sdist
fi

LICENSE="CC-BY-SA-3.0"
SLOT="0"
IUSE="eventlet gevent"

RDEPEND="${PYTHON_DEPS}
	eventlet? ( dev-python/eventlet[${PYTHON_USEDEP}] )
	gevent? ( dev-python/gevent[${PYTHON_USEDEP}] )
"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/versioningit[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" -m pytest -v test/test_daemon.py \
		|| die "Testing failed with ${EPYTHON}"
}
