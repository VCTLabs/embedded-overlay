# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Latest UCM fix branch for arm64 Lenovo thinkpad laptops, eg x13s"
HOMEPAGE="https://github.com/VCTLabs/alsa-ucm-conf.git"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/alsa-ucm-conf.git"
	EGIT_BRANCH="x13s-volume-fixes"
	#EGIT_COMMIT="e8c3e7792336e9f68aa560db8ad19ba06ba786bb"
	inherit git-r3
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/refs/heads/x13s-volume-fixes.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"
	S="${WORKDIR}/${PN}-x13s-volume-fixes"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="!<media-libs/alsa-lib-1.2.1"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/alsa
	doins -r ucm{,2}
}
