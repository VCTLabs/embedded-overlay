# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..12} )

inherit gnome2-utils meson python-single-r1 xdg

DESCRIPTION="A simple drawing application for Linux"
HOMEPAGE="https://maoschanz.github.io/drawing/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/maoschanz/drawing.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/maoschanz/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="gnome"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"

RDEPEND="${DEPEND}
	>=dev-python/pygobject-3.10.2:3[cairo]
	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3.12:3[introspection]
	gnome? ( gnome-base/gsettings-desktop-schemas )
"

BDEPEND=">=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	dev-util/desktop-file-utils
	dev-libs/appstream-glib[introspection]
"

pkg_preinst() {
	gnome2_schemas_savelist
	xdg_pkg_preinst
}

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}"/usr/bin/
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_pkg_postrm
}
