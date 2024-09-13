# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="MAVLink protocol streams and log files in Python"
HOMEPAGE="https://pypi.org/project/pymavlink/"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="regen test"

RDEPEND="${PYTHON_DEPS}
	dev-embedded/mavlink_c
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}] )"

DOCS=( README.md )

# tests are not currently included in pypi source dist
RESTRICT="test"

export MDEF=/usr/include/mavlink/message_definitions

distutils_enable_tests pytest

src_prepare() {
    sed -i "/'future'/d" "${S}"/setup.py
    default
}

python_prepare_all() {
	if ! use regen ; then
		export NOGEN=true
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=.. pytest -vv tests  || die "tests failed under ${EPYTHON}"
}
