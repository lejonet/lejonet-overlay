# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Build a global ethernet network based on sanctum."
HOMEPAGE="https://conclave.se/"
SRC_URI="https://conclave.se/releases/${PN}/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libkyrka"
RDEPEND="${DEPEND}"

src_install() {
	dobin tier6

	newinitd "${FILESDIR}/tier6.initd" tier6
	newconfd "${FILESDIR}/tier6.confd" tier6
}
