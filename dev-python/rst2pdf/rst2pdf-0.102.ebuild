# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Tool for transforming reStructuredText to PDF using ReportLab"
HOMEPAGE="https://rst2pdf.org/ https://pypi.org/project/rst2pdf/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="math sphinx svg"

BDEPEND="${PYTHON_DEPS}
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/smartypants[${PYTHON_USEDEP}]
	>=dev-python/reportlab-2.6[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	math? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	svg? ( dev-python/svglib[${PYTHON_USEDEP}] )
	sphinx? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

# restrict tests because: the price is way too high (in both developer time
# to unhork and cost per megawatt in cpu power)
RESTRICT="test"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_install() {
	distutils-r1_src_install
	pushd "${S}/doc" > /dev/null
		rst2man rst2pdf.rst output/rst2pdf.1
	popd > /dev/null
	doman doc/output/rst2pdf.1
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "rst2pdf can work with the following packages for additional functionality:"
		elog "   dev-python/sphinx       - versatile documentation creation"
		elog "   dev-python/pythonmagick - image processing with ImageMagick"
		elog "   dev-python/matplotlib   - mathematical formulae"
		elog "It can also use wordaxe for hyphenation, but this package is not"
		elog "available in the portage tree yet. Please refer to the manual"
		elog "installed in /usr/share/doc/${PF}/ for more information."
	fi
}
