# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="x13s-alarm"

inherit eutils

DESCRIPTION="The missing fw bits for Lenovo thinkpad x13s (temporary)"
HOMEPAGE="https://github.com/ironrobin/x13s-alarm/tree/trunk/x13s-firmware"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/ironrobin/${MY_PN}.git"
	EGIT_BRANCH="trunk"
	inherit git-r3
else
	GIT_COMMIT="04e2f717a32f28d756b37a5f4cf759528b4834b1"
	SRC_URI="https://github.com/ironrobin/${MY_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
	S="${WORKDIR}"/${MY_PN}-${GIT_COMMIT}
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

src_install() {
	install -d ${D}/lib/firmware/qca ${D}/lib/firmware/qcom/sc8280xp
	# BT firmware
	cp -v x13s-firmware/hpnv21.8c ${D}/lib/firmware/qca/
	# GPU firmware
	cp -v x13s-firmware/a690_*  ${D}/lib/firmware/qcom/
	# audio firmware
	cp -v x13s-firmware/SC8280XP-LENOVO-X13S-tplg.bin ${D}/lib/firmware/qcom/sc8280xp/
}
