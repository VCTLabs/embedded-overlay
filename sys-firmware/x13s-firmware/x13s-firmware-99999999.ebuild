# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="x13s-alarm"

DESCRIPTION="The missing/updated fw bits for Lenovo thinkpad x13s"
HOMEPAGE="https://github.com/ironrobin/x13s-alarm/tree/trunk/x13s-firmware"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/ironrobin/${MY_PN}.git"
	EGIT_BRANCH="trunk"
	inherit git-r3
else
	GIT_COMMIT="35c448cf104887bbbd8154e62f8fb1da46475173"
	SRC_URI="https://github.com/ironrobin/${MY_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
	S="${WORKDIR}"/${MY_PN}-${GIT_COMMIT}
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	net-wireless/bluez
	sys-kernel/linux-firmware
"
RESTRICT="strip test"

QA_PREBUILT="*"

src_install() {
	install -d "${D}"/lib/firmware/qca "${D}"/lib/firmware/qcom/sc8280xp/LENOVO/21BX
	# BT firmware
	cp -v x13s-firmware/hpnv21.b8c "${D}"/lib/firmware/qca/
	# GPU firmware
	cp -v x13s-firmware/a690_gmu.bin "${D}"/lib/firmware/qcom/
	# audio firmware
	cp -v x13s-firmware/qcvss8280.mbn "${D}"/lib/firmware/qcom/sc8280xp/LENOVO/21BX/

	# include BT bdaddr fix for 6.3+
	newinitd "${FILESDIR}"/bdaddr-init bdaddr
	newconfd "${FILESDIR}"/bdaddr-conf bdaddr
}
