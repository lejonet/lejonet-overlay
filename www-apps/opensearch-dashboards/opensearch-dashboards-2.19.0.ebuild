# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Open source visualization dashboards for OpenSearch. "
HOMEPAGE="https://opensearch.org/"
SRC_URI="https://artifacts.opensearch.org/releases/bundle/${PN}/${PV}/${P}-linux-x64.tar.gz"

LICENSE="Apache-2.0 BSD MIT ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bundled-nodejs"

DEPEND="acct-group/opensearch-dashboards
	acct-user/opensearch-dashboards"
RDEPEND="${DEPEND}
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	!bundled-nodejs? (
		>=net-libs/nodejs-18
		<net-libs/nodejs-19
	)"

src_prepare() {
	default

	# remove unused directory
	rm -r data || die

	if ! use bundled-nodejs; then
		# remove bundled nodejs
		rm -r node || die

		# handle node.js version with RDEPEND
		sed -i /node_version_validator/d src/setup_node_env/no_transpilation.js || die
	fi
}

src_install() {
	insinto /etc/${PN}
	doins -r config/.
	rm -r config || die

	diropts -m 0750 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /usr/share/${PN}
	doins -r .

	fperms -R +x /usr/share/${PN}/bin

	diropts -m 0750 -o ${PN} -g ${PN}
	keepdir /var/log/${PN}
	keepdir /var/cache/${PN}
	keepdir /var/lib/${PN}

	fowners -R opensearch-dashboards:opensearch-dashboards /usr/share/${PN}
	fowners -R opensearch-dashboards:opensearch-dashboards /var/lib/${PN}
	fowners -R opensearch-dashboards:opensearch-dashboards /var/cache/${PN}
	fowners -R opensearch-dashboards:opensearch-dashboards /etc/${PN}
}
