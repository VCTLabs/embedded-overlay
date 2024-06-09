# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="Userspace reference for net/qrtr in the Linux kernel."
HOMEPAGE="https://github.com/andersson/qrtr"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andersson/qrtr.git"
else
	SRC_URI="https://github.com/andersson/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~arm ~arm64"
fi

SLOT="0"
LICENSE="BSD"
IUSE=""

DEPEND=""

src_install() {
	meson_src_install
	newinitd "${FILESDIR}/${PN}-ns".init "${PN}-ns"
}
