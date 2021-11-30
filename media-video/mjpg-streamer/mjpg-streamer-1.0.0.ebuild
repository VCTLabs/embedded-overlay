# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake systemd

DESCRIPTION="MJPG-streamer takes JPGs from Linux-UVC compatible webcams"
HOMEPAGE="https://github.com/jacksonliam/mjpg-streamer"

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jacksonliam/mjpg-streamer.git"
else
	SRC_URI="https://github.com/jacksonliam/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

INPUT_PLUGINS="input-testpicture input-control input-file input-uvc input-http input-opencv input-ptp2 input-raspicam"
OUTPUT_PLUGINS="output-file output-udp output-http output-autofocus output-rtsp output-viewer output-zmqserver"
IUSE_PLUGINS="${INPUT_PLUGINS} ${OUTPUT_PLUGINS}"

IUSE="input-testpicture input-control +input-file +input-uvc input-http input-opencv input-ptp2 input-raspicam
	output-file output-udp +output-http output-autofocus +output-rtsp output-viewer output-zmqserver
	test www http-management wxp-compat"

REQUIRED_USE="|| ( ${INPUT_PLUGINS} )
	|| ( ${OUTPUT_PLUGINS} )"

RESTRICT="!test? ( test )"

RDEPEND="virtual/jpeg
	media-libs/libv4l
	input-uvc? ( acct-group/video )
	input-opencv? ( media-libs/opencv )
	input-ptp2? ( media-libs/libgphoto2 )
	input-raspicam? (
		|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	)
	output-zmqserver? (
		dev-libs/protobuf-c
		net-libs/zeromq
	)"

DEPEND="${RDEPEND}
	input-testpicture? ( media-gfx/imagemagick )"

PATCHES=(
	"${FILESDIR}/${PN}-cmake-cleanup.patch"
	"${FILESDIR}/${PN}-opencv-arg-enable.patch"
)

S="${WORKDIR}/${P}/${PN}-experimental"

src_prepare() {
	local flag switch
	for flag in ${IUSE_PLUGINS}; do
		use ${flag} && switch='' || switch='#'
		flag=${flag/input-/input_}
		flag=${flag/output-/output_}
		sed -i -e \
			"s|^add_subdirectory(plugins\/${flag})|${switch}add_subdirectory(plugins/${flag})|" \
			CMakeLists.txt || die
	done

	sed -e "s|@LIBDIR@|$(get_libdir)/${PN}/$(get_libdir)|g" \
		"${FILESDIR}/${PN}.initd" > ${PN}.initd || die

	cmake_src_prepare
}

src_configure() {
	# MJPG_STREAMER_PLUGIN_INSTALL_PATH if needed
	local mycmakeargs=(
		-DENABLE_WXP_COMPAT=$(usex wxp-compat)
		-DENABLE_HTTP_MANAGEMENT=$(usex http-management)
		-DENABLE_INPUT_OPENCV=$(usex input-opencv)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cmake_run_in "${BUILD_DIR}" ctest --verbose
}

src_install() {
	cmake_src_install

	newinitd ${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit mjpg_streamer@.service
}

pkg_postinst() {
	einfo
	elog "Remember to set an input and output plugin for mjpg-streamer."

	if use input-uvc ; then
		elog "To use the UVC plugin as a regular user, you must be a part of the video group"
	fi

	if use www ; then
		einfo
		elog "An example webinterface has been installed into"
		elog "/usr/share/mjpg-streamer/www for your usage."
	fi
	einfo
}
