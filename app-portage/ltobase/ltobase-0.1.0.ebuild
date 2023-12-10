# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A base LTO override configuration for portage"
HOMEPAGE="https://github.com/VCTLabs/embedded-overlay"

# Note: there's nothing preventing this from working on stable
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
IUSE="clang"

# portage-bashrc-mv or runtitle can be installed from mv overlay
DEPEND="
    sys-apps/portage
    sys-devel/binutils-config
    sys-devel/gcc-config
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"
DOCS=""

# Test binutils and gcc version
pkg_setup() {

    ACTIVE_GCC=$(gcc-fullversion)

    if ver_test "${ACTIVE_GCC}" -lt 10.2.0; then
        ewarn "Warning: Active GCC version '$ACTIVE_GCC' is lower then the expected version '10.2.0', it is recommended that you use the newest GCC if you want LTO."
        if [ "${I_KNOW_WHAT_I_AM_DOING}" != "y" ]; then
            eerror "Aborting LTObase installation due to older GCC version '$ACTIVE_GCC' -- set I_KNOW_WHAT_I_AM_DOING=y if you want to override this behaviour."
            die
        else
            ewarn "I_KNOW_WHAT_I_AM_DOING=y -- continuing anyway"
        fi
    fi

    if [ -f "${PORTAGE_CONFIGROOT%/}/etc/portage/package.env" ]; then
        eerror "${PORTAGE_CONFIGROOT%/}/etc/portage/package.env is a file not a directory.  Please convert package.env to a directory with the current contents of package.env being moved to a file inside it."
        die
    fi
}

src_install() {
    local BASE_CONFIG="env package.env patches"
    local PKG_ENV="link-dl  link-m  noltobuild ruby"
    local ENV_CONF="nolto.conf  plus-dl.conf  plain.conf"
    dodir /etc/ltobase
    insinto /etc/ltobase
    doins "${FILESDIR}/make.conf.lto"
    for dir in $BASE_CONFIG ; do
        doins -r "${FILESDIR}/$dir"
    done

    dodir /etc/portage/env /etc/portage/package.env
    dosym -r /etc/ltobase/make.conf.lto /etc/portage/make.conf.lto
    for file in $PKG_ENV ; do
        dosym -r /etc/ltobase/package.env/$file /etc/portage/package.env/$file
    done
    for file in $ENV_CONF ; do
        dosym -r /etc/ltobase/env/$file /etc/portage/env/$file
    done
}

pkg_postinst() {

    elog "If you have not done so, you will need to modify your make.conf settings to enable LTO building on your system."
    elog "A symlink has been placed in ${PORTAGE_CONFIGROOT%/}/etc/portage/make.conf.lto that can be used as a basis for these modifications."
    elog "See README.rst for more details."

    elog "If you add an override for a particular package, please consider sending a pull request upstream so that other users of this repository can benefit."
    ewarn "You will require a complete system rebuild in order to gain the benefits of LTO system-wide."
    echo

    BINUTILS_VER=$(binutils-config ${CHOST} -c | sed -e "s/.*-//")

    if ver_test "${BINUTILS_VER}" -lt 2.34; then
        ewarn "Warning: active binutils version < 2.34, it is recommended that you use the newest binutils for LTO."
    fi
}
