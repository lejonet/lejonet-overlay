# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Take control over your live stream video by running it yourself. Streaming + chat out of the box."
HOMEPAGE="https://owncast.online"
<<<<<<< HEAD
SRC_URI="https://github.com/owncast/owncast/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
=======
SRC_URI="https://github.com/owncast/owncast/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
https://files.dataaturservice.se/${P}-deps.tar.xz"
>>>>>>> cda5cf3 (Bump version of owncast to 0.2.4)

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-user/owncast
	acct-group/owncast
	media-video/ffmpeg[x264]
	>=dev-lang/go-1.20
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	ego build -v
}

src_install() {
	diropts -g owncast -o owncast -m 0750
	keepdir /var/log/owncast
	keepdir /var/lib/owncast
	dobin owncast
	newconfd "${FILESDIR}/conf.d" owncast
	newinitd "${FILESDIR}/init.d" owncast
}
