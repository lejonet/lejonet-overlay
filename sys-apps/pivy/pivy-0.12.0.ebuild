# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tools for using PIV tokens (like Yubikeys) as an SSH agent, for encrypting data at rest, and more"
HOMEPAGE="https://github.com/arekinath/pivy"
SRC_URI="https://github.com/arekinath/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

DEPEND="dev-libs/libbsd
	dev-libs/libedit
	app-crypt/libmd
	sys-libs/ncurses
	sys-apps/pcsc-lite[policykit]"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	if use hardened; then
		PATCHES+=( "${FILESDIR}"/change-fortify-source-in-makefile.patch )
	fi
	default
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
}
