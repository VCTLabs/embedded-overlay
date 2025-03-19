# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="An ambient sound player for Gnome desktop"
HOMEPAGE="https://github.com/rafaelmardojai/blanket"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/rafaelmardojai/blanket.git"
	EGIT_BRANCH="playback-rework"
	inherit git-r3
else
	SRC_URI="https://github.com/rafaelmardojai/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.76.0:2
	>=gui-libs/gtk-4.11.3:4[gstreamer,introspection]
	>=gui-libs/libadwaita-1.4:1[introspection,vala]
	>=media-libs/gstreamer-1.4:1.0[introspection]
"

RDEPEND="${DEPEND}
	>=dev-python/pygobject-3.10.2:3[cairo]
	>=media-libs/gst-plugins-bad-1.4:1.0
"

BDEPEND="virtual/pkgconfig
	>=sys-devel/gettext-0.19.8
        amd64? ( dev-util/blueprint-compiler )
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
