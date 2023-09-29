# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Shell script daemon for fstrim to maintain ssd drive performance"
HOMEPAGE="https://github.com/dobek/fstrimDaemon"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/dobek/fstrimDaemon.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/dobek/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE="systemd"

RDEPEND="sys-apps/util-linux"

DEPEND="${RDEPEND}"

DOCS=( README.md )

src_compile() {
	:
}

src_install() {
	dosbin usr/sbin/fstrimDaemon.sh
	if ! use systemd ; then
		sed -i -e "s|sbin/runscript|sbin/openrc-run|" etc/init.d/fstrimDaemon
		doinitd etc/init.d/fstrimDaemon
		doconfd etc/conf.d/fstrimDaemon
	else
		systemd_dounit usr/lib/systemd/system/fstrimDaemon.service
	fi
}
