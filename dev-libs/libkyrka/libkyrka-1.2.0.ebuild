# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Libkyrka is a library based implementation of the sanctum VPN protocol."
HOMEPAGE="https://sanctorum.se/"
SRC_URI="https://sanctorum.se/releases/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libsodium"
RDEPEND="${DEPEND}"

src_install() {
	emake PREFIX="${D}/usr" LIB_DIR="${D}/usr/lib64" install
}
