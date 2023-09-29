# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The missing alsa UCM bits for Lenovo thinkpad x13s (temporary)"
HOMEPAGE="https://git.linaro.org/people/srinivas.kandagatla/alsa-ucm-conf.git"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.linaro.org/people/srinivas.kandagatla/${PN}.git"
	EGIT_BRANCH="x13s"
	#EGIT_COMMIT="f0904c6c49332cafdb731004c19bfd1655cccdcf"
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
