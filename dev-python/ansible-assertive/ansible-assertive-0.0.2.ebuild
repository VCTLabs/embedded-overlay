# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Make assert more useful for infrastructure testing"
HOMEPAGE="https://github.com/sarnold/ansible-assertive"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/ansible-assertive"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="examples"

DEPEND="app-admin/ansible[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="test"

DOCS=( README.md )

src_compile() {
	:
}

python_install() {
	#python_export PYTHON_SITEDIR

	ansible_shared="/usr/share/ansible"
	ansible_plugins="${ansible_shared}/plugins"
	einfo "Using plugin path ${ansible_plugin_path} ..."
	insinto "${ansible_plugins}/callback"
	doins callback_plugins/assertive.py
	insinto "${ansible_plugins}/action"
	doins action_plugins/assert.py
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r examples/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	CFG_FILE="/etc/ansible/ansible.cfg"
	if [[ -e "${CFG_FILE}" ]]; then
		einfo "See the readme on configuring the callback plugin in ${CFG_FILE}:"
	else
		ewarn "You need to create ${CFG_FILE} to configure the callback plugin:"
	fi
	einfo ""
	einfo "callback_whitelist = assertive"
	einfo ""
}
