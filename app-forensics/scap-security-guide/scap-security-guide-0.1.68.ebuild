# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
MY_PN="content"

inherit cmake python-single-r1

HOMEPAGE="https://www.open-scap.org/security-policies/scap-security-guide"
DESCRIPTION="Security automation content in SCAP, Bash, Ansible, and other formats"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/ComplianceAsCode/${MY_PN}/releases/download/v${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	#S="${WORKDIR}/${MY_PN}-${PV}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ComplianceAsCode/${MY_PN}.git"
fi

LICENSE="BSD"
SLOT="0/3"
IUSE="ansible bash"

DEPEND="
	dev-libs/expat
	dev-libs/libxml2
	dev-libs/libxslt
	dev-python/jinja
	dev-python/pyyaml
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}
	app-forensics/openscap
	ansible? ( app-admin/ansible )
	bash? ( app-shells/bash )
"
BDEPEND="virtual/pkgconfig
	dev-python/setuptools
	${PYTHON_DEPS}
"

DOCS=( README.md )
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	ln -snf "${BUILD_DIR}" "${S}"/build

	local mycmakeargs=(
		-DSSG_ANSIBLE_PLAYBOOKS_ENABLED="$(usex ansible)"
		-DSSG_BASH_SCRIPTS_ENABLED="$(usex bash)"
		-DSSG_OVAL_SCHEMATRON_VALIDATION_ENABLED=OFF
	)

	cmake_src_configure
}
