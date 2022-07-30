# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A command-line tool for rounding images"
HOMEPAGE="https://github.com/mingrammer/round"
SRC_URI="https://github.com/mingrammer/round/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/${PVR}"
KEYWORDS="amd64"

RESTRICT+=" test"

src_compile() {
	go build -mod=vendor . || die
}

src_install() {
	dobin ${PN}
	einstalldocs
}
