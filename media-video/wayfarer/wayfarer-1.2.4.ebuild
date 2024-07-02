# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Modern screen recorder for GNOME / Wayland / pipewire"
HOMEPAGE="https://github.com/stronnag/wayfarer"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/stronnag/wayfarer.git"
	EGIT_BRANCH="development"
	inherit git-r3
else
	SRC_URI="https://github.com/stronnag/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RESTRICT="test"

RDEPEND="
	media-libs/gstreamer:1.0
	media-plugins/grilo-plugins[lua]
	>=dev-util/gtk-update-icon-cache-3
"

DEPEND="${RDEPEND}
	>=dev-libs/glib-2.66
	>=gui-libs/gtk-4.0.0:4[X,wayland,introspection,gstreamer]
	>=gui-libs/libadwaita-1.4:1[introspection,vala]
	media-libs/libpulse[glib]
	x11-base/xorg-proto
"

PDEPEND="
	gnome-base/librsvg:2
	>=x11-themes/adwaita-icon-theme-3.14
"

BDEPEND="
	$(vala_depend)
	dev-libs/glib
	dev-util/glib-utils
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_setup

	sed -e "s:valac :${VALAC} :" \
		-i src/getinfo.sh || die
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
