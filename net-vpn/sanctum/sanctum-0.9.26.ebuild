# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles

DESCRIPTION="A small, reviewable, experimental and fully privilege seperated VPN daemon."
HOMEPAGE="https://sanctorum.se/sanctum/"
SRC_URI="https://sanctorum.se/sanctum/releases/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libsodium[cpu_flags_x86_aes]"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	diropts -m0700
	keepdir /etc/sanctum

	newinitd "${FILESDIR}/sanctum.initd" sanctum
	newconfd "${FILESDIR}/sanctum.confd" sanctum

	newtmpfiles "${FILESDIR}/sanctum.tmpfiles.d" sanctum.conf
}

pkg_postinst() {
	tmpfiles_process sanctum.conf
}
