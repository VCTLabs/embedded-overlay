# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=(python3_{10..13})

inherit distutils-r1

DESCRIPTION="Pythonic API to the Linux uinput kernel module"
HOMEPAGE="http://tjjr.fi/sw/python-uinput/"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/tuomasjjrasanen/python-uinput"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/tuomasjjrasanen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="virtual/udev"
RDEPEND="${DEPEND}"

DOCS="AUTHORS NEWS.rst README.rst"

python_prepare_all() {
	rm libsuinput/src/libudev.h || die
	distutils-r1_python_prepare_all
}
