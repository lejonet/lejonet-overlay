# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Infrastructure as code for DNS!"
HOMEPAGE="https://dnscontrol.org"
SRC_URI="https://github.com/DNSControl/dnscontrol/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.26"

src_compile() {
	ego build
}

src_install() {
	dobin dnscontrol

	default
}
