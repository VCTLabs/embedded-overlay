# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KVER_ARM64="${PV}-arm64-${PR}"

DESCRIPTION="Simple kernel bin install of image, modules, and dtbs"
HOMEPAGE="https://github.com/sarnold/arm64-mainline-linux"

BASE_URI="https://github.com/sarnold/arm64-mainline-linux/releases/download"
SRC_URI="
	arm64? (
		"${BASE_URI}/6.7-arm64-r1/${KVER_ARM64}.Image"
		"${BASE_URI}/6.7-arm64-r1/config-${KVER_ARM64}"
		"${BASE_URI}/6.7-arm64-r1/${KVER_ARM64}-modules.tar.gz"
		"${BASE_URI}/6.7-arm64-r1/${KVER_ARM64}-dtbs.tar.gz"
	)
"
LICENSE="GPL-2"
RESTRICT="bindist mirror test strip"
SLOT="0"
KEYWORDS="-* ~arm64"

S="${WORKDIR}"

RDEPEND="
	sys-libs/zlib:0/1
"

QA_PREBUILT="*"

src_install() {
	rm "${S}"/lib/modules/"${KVER_ARM64}"/{build,source}
	mv "${S}"/lib "${ED}"/ || die
	dodir /boot/dtbs/"${KVER_ARM64}"
	mv "${S}"/* "${ED}/boot/dtbs/${KVER_ARM64}/"
	cp "${DISTDIR}/${KVER_ARM64}.Image" "${ED}/boot/vmlinuz-${KVER_ARM64}"
	cp "${DISTDIR}/config-${KVER_ARM64}" "${ED}/boot/"
	elog "Do not forget to run dracut and/or grub-mkconfig !!"
}
