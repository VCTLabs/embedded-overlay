# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 xdg-utils

DESCRIPTION="An ambient noise player for Gnome desktop"
HOMEPAGE="https://costales.github.io/projects/anoise/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/anoise.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	MY_PV_COMMIT="c9ba9268ca602e9448b15be0d1a5b6ce4c00ca23"
	# sadly the LP source tarball is broken
	#SRC_URI="https://launchpad.net/~costales/+archive/ubuntu/anoise/+sourcefiles/anoise/0.0.36/anoise_0.0.36.tar.gz"
	SRC_URI="
		https://github.com/costales/anoise/archive/${MY_PV_COMMIT}.tar.gz -> ${P}.gh.tar.gz
		https://launchpad.net/~costales/+archive/ubuntu/anoise/+sourcefiles/anoise-media/0.0.17/anoise-media_0.0.17.tar.gz
	"
	SRC_URI+=" gui? ( https://launchpad.net/~costales/+archive/ubuntu/anoise/+sourcefiles/anoise-gui/0.0.4/anoise-gui_0.0.4.tar.gz )"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV_COMMIT}"
fi

IUSE="+gui"
LICENSE="GPL-3"
SLOT="0"
RESTRICT="test"

DEPEND="${PYTHON_DEPS}"

RDEPEND="${DEPEND}
	dev-libs/gobject-introspection
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/gst-python[${PYTHON_USEDEP}]
	')
	dev-libs/libappindicator[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	virtual/notification-daemon
	virtual/freedesktop-icon-theme
"

BDEPEND="
	virtual/pkgconfig
	$(python_gen_cond_dep '
		dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	')
	sys-devel/gettext
"

src_prepare() {
	# remove hard-coded prefix
	sed -i -e "s|/usr/||" setup.py
	# revbump WebKit2 typelib
	sed -i -e "s|4.0')|4.1')|" anoise/preferences.py
	default
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/"${PN}"
	use gui && doins "${WORKDIR}"/"${PN}"-gui/"${PN}"/{anoise.ui,view.py}
	doins -r "${WORKDIR}"/media/sounds
	rm -r "${ED}"/usr/share/doc/anoise || die
	rm -f "${ED}"/usr/share/applications/anoise.desktop || die
	insinto /usr/share/applications
	doins "${FILESDIR}"/anoise.desktop

	python_optimize
	python_fix_shebang "${ED}"/usr/share/anoise
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
