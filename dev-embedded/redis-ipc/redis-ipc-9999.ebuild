# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..9} )

inherit autotools ltprune python-r1 toolchain-funcs

DESCRIPTION="A client library for using redis as IPC msg/event bus."
HOMEPAGE="https://github.com/VCTLabs/redis-ipc"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/redis-ipc.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE="+pic python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="dev-libs/hiredis:=
	dev-libs/json-c"

RDEPEND="${DEPEND}
	python? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/redis-py[${PYTHON_USEDEP}]')
	)
	dev-db/redis"

DOCS=( README.rst )

# tests require a running redis server
RESTRICT="test"

python_check_deps() {
	has_version "dev-python/redis-py[${PYTHON_USEDEP}]"
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with pic)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	prune_libtool_files --all

	# redis_ipc.py
	if use python; then
		python_foreach_impl python_domodule redis_ipc.py
	fi
}
