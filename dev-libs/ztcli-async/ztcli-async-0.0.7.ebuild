# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A Python aio client wrapper for the zerotier-cli node API"
HOMEPAGE="https://github.com/sarnold/ztcli-async"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/ztcli-async.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="
	|| (
		dev-python/async-timeout[${PYTHON_USEDEP}]
		dev-python/async_timeout[${PYTHON_USEDEP}]
	)
	dev-python/aiohttp[${PYTHON_USEDEP}]
"

RESTRICT="test"
