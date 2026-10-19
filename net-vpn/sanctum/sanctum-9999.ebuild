# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles git-r3

EGIT_REPO_URI="https://github.com/jorisvink/sanctum"

DESCRIPTION="A small, reviewable, experimental and fully privilege seperated VPN daemon."
HOMEPAGE="https://sanctorum.se/sanctum/"

LICENSE="ISC"
SLOT="0"

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
