# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="MessagePack (de)serializer for Python"
HOMEPAGE="https://msgpack.org
	https://github.com/msgpack/msgpack-python/
	https://pypi.org/project/msgpack/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"
IUSE="+native-extensions test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	native-extensions? (
		$(python_gen_cond_dep '>=dev-python/cython-0.16[${PYTHON_USEDEP}]' 'python*')
	)
	test? (	dev-python/six[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove pre-generated cython files
	rm msgpack/{_packer,_unpacker,_cmsgpack}.pyx || die

	if ! use native-extensions ; then
		sed -i -e "/have_cython/s:True:False:" setup.py || die
	fi
	distutils-r1_python_prepare_all
}
