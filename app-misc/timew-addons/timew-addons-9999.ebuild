# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 xdg-utils

DESCRIPTION="Graphical user interface for monitoring timew status"
HOMEPAGE="https://github.com/sarnold/timew-addons"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/timew-addons.git"
	EGIT_BRANCH="main"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="gnome"

# no tests except pylint, so...
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libappindicator[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	virtual/notification-daemon
	x11-themes/hicolor-icon-theme
	app-misc/timew
	gnome? ( gnome-extra/gnome-shell-extension-appindicator )
	dev-python/xmltodict[${PYTHON_USEDEP}]
"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.20.0[${PYTHON_USEDEP}]
"
# using gnome use flag with this makes repoman choke, but if you actually have
# a gnome desktop you may want to install this:
#   gnome-extra/gnome-shell-extension-appindicator
# but for xfce4 you probably want this:
#   xfce-extra/xfce4-notifyd

#export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
