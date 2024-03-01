# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

DESCRIPTION="An interface for Timewarrior report data"
HOMEPAGE="https://github.com/lauft/timew-report"
SRC_URI="https://github.com/lauft/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="${PYTHON_DEPS}
	app-misc/timew"

DEPEND="${PYTHON_DEPS}
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
