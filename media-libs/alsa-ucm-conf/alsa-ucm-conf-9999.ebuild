# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="UCM fix branch for arm64 laptops merged in 9999 only"
HOMEPAGE="https://github.com/alsa-project/alsa-ucm-conf.git"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/alsa-project/alsa-ucm-conf.git"
	#EGIT_COMMIT="9fd2f06a2c0fdd19b2cdae7d699b18e7d775940f"
	inherit git-r3
else
	SRC_URI="https://www.alsa-project.org/files/pub/lib/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"
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
