# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="view/edit binary with any text editor"
HOMEPAGE="https://github.com/sarnold/hexdump"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/hexdump.git"
	EGIT_BRANCH="main"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV="${PV/_p/-}"
	SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="!test? ( test )"

python_prepare_all() {
	einfo "The commandline script is installed as hexdumper to avoid"
	einfo "collisions with the util-linux hexdump command.  Note the"
	einfo "import name is still <hexdump>."
	sed -i -e "s|hexdump =|hexdumper =|" "${S}"/setup.cfg

	distutils-r1_python_prepare_all
}

python_test() {
	#distutils_install_for_testing
	"${S}"/hexdump --test || die "Test failed with ${EPYTHON}"
}
