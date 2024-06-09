# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Diagram as Code for prototyping cloud system architectures"
HOMEPAGE="
	https://github.com/mingrammer/diagrams
	https://diagrams.mingrammer.com/
"
SRC_URI="
	https://github.com/mingrammer/diagrams/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/graphviz[${PYTHON_USEDEP}]
"

# optional dev dependencies include:
# dev-go/round  (embedded-overlay)
# media-gfx/inkscape
# media-gfx/imagemagick

PATCHES=( "${FILESDIR}/${PN}-fix-pyproject-build-system.patch" )

distutils_enable_tests pytest
