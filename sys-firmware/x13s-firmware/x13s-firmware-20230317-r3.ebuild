# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="x13s-alarm"

inherit eutils

DESCRIPTION="The missing/updated fw bits for Lenovo thinkpad x13s"
HOMEPAGE="https://github.com/ironrobin/x13s-alarm/tree/trunk/x13s-firmware"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/ironrobin/${MY_PN}.git"
	EGIT_BRANCH="trunk"
	inherit git-r3
else
	GIT_COMMIT="7e469c9c963ad7b5494302833f2ecc798e330d66"
	SRC_URI="https://github.com/ironrobin/${MY_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
	S="${WORKDIR}"/${MY_PN}-${GIT_COMMIT}
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	!sys-kernel/linux-firmware[-savedconfig]
"

src_install() {
	install -d ${D}/lib/firmware/qca ${D}/lib/firmware/qcom/sc8280xp ${D}/lib/firmware/ath11k/WCN6855/hw2.0/ ${D}/lib/firmware/ath11k/WCN6855/hw2.1/
	# WLAN firmware - collision with linux-firmware, remove board file from
	# linux-firmware savedconfig file first
	cp -v x13s-firmware/board-2.bin ${D}/lib/firmware/ath11k/WCN6855/hw2.0/
	dosym ../hw2.0/board-2.bin /lib/firmware/ath11k/WCN6855/hw2.1/board-2.bin
	# BT firmware
	cp -v x13s-firmware/hpnv21.8c ${D}/lib/firmware/qca/
	# GPU firmware
	cp -v x13s-firmware/a690_*  ${D}/lib/firmware/qcom/
	# audio firmware
	cp -v x13s-firmware/SC8280XP-LENOVO-X13S-tplg.bin ${D}/lib/firmware/qcom/sc8280xp/

	# include BT bdaddr fix for 6.3+
	newinitd "${FILESDIR}"/bdaddr-init bdaddr
	newconfd "${FILESDIR}"/bdaddr-conf bdaddr
}
