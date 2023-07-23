# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake bash-completion-r1 python-single-r1

HOMEPAGE="https://www.open-scap.org/tools/openscap-base"
DESCRIPTION="NIST Certified SCAP 1.2 toolkit"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/OpenSCAP/openscap/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenSCAP/openscap.git"
fi

LICENSE="LGPL-2.1"
SLOT="0/1"
IUSE="+acl +caps debug doc ldap nss +perl +python rpm selinux sce sql test +xattr"

RDEPEND="!nss? ( dev-libs/libgcrypt:0 )
	nss? ( dev-libs/nss )
	acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	ldap? ( net-nds/openldap )
	rpm? ( >=app-arch/rpm-4.9 )
	sql? ( dev-db/opendbx )
	xattr? ( sys-apps/attr )
	dev-libs/libpcre
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/xmlsec
	dev-libs/dbus-glib
	dev-libs/glib
	dev-libs/popt
	net-misc/curl
	sys-apps/dbus
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )
	test? (
		app-arch/unzip
		dev-perl/XML-XPath
		net-misc/ipcalc
		sys-apps/grep )"

RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
PATCHES=(
	"${FILESDIR}/${PN}-fix-default-perl-install-path.patch"
	"${FILESDIR}/run-a-minor-testsuite.patch"
	"${FILESDIR}/${PN}-fix-QA-warnings-with-newer-toolchain.patch"
)

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DENABLE_OSCAP_REMEDIATE_SERVICE=OFF
		-DENABLE_PERL="$(usex perl)"
		-DENABLE_PYTHON3="$(usex python)"
		-DOPENSCAP_PROBE_UNIX_GCONF=OFF
		-DGCONF_LIBRARY=
		-DENABLE_DOCS="$(usex doc)"
	)

	cmake_src_configure
}
