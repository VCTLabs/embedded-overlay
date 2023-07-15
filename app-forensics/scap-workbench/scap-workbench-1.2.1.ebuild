# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HOMEPAGE="https://www.open-scap.org/tools/openscap-base"
DESCRIPTION="SCAP Scanner And Tailoring Graphical User Interface"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/OpenSCAP/${PN}/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenSCAP/openscap.git"
fi

LICENSE="GPL-3"
SLOT="0/3"
IUSE="gnome"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxmlpatterns:5
	app-forensics/openscap
"
RDEPEND="${DEPEND}
	gnome? ( net-misc/ssh-askpass-fullscreen )
	app-forensics/scap-security-guide
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/0001-fix-doc-generation.patch"
	"${FILESDIR}/0002-Fix-build-warning.patch"
	"${FILESDIR}/0003-Move-appdata-to-appropriate-location.patch"
	"${FILESDIR}/0004-Fix-deprecated-format-appdata.patch"
	"${FILESDIR}/0005-Turn-off-rpath.patch"
	"${FILESDIR}/0006-Add-Keywords-entry-for-desktop-file.patch"
	"${FILESDIR}/0001-fix-qt_version_check-5.15-5.14.patch"
	"${FILESDIR}/0001-fix-loop-variable-range-use-ref-value.patch"
)

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DOPENSCAP_INCLUDE_DIRS=/usr/include/openscap/
	)

	cmake_src_configure
}
