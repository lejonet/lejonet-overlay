# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Open source visualization dashboards for OpenSearch, Wazuh edition. "
HOMEPAGE="https://wazuh.com"
SRC_URI="https://packages.wazuh.com/4.x/apt/pool/main/w/${PN}/${PN}_${PV}-1_amd64.deb"
S="${WORKDIR}"

LICENSE="Apache-2.0 BSD MIT ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/opensearch-dashboards
	acct-user/opensearch-dashboards"
RDEPEND="${DEPEND}
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
"

QA_PRESTRIPPED="/usr/share/wazuh-dashboard/node/bin/node
/usr/share/wazuh-dashboard/node/fallback/bin/node"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}"/data.tar.xz
}

src_install() {
	insinto /etc/
	doins -r "${WORKDIR}"/etc/wazuh-dashboard

	insinto /etc/default
	doins "${WORKDIR}"/etc/default/wazuh-dashboard

	diropts -m 0750 -o opensearch-dashboards -g opensearch-dashboards

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}".logrotate "${PN}"

	newinitd "${FILESDIR}/${PN}".initd "${PN}"
	newconfd "${FILESDIR}/${PN}".confd "${PN}"

	dodir /usr/share
	cp -ar "${WORKDIR}"/usr/share/wazuh-dashboard "${ED}"/usr/share || die "Failed to copy /usr/share/wazuh-dashboard"

	diropts -m 0750 -o opensearch-dashboards -g opensearch-dashboards
	keepdir /var/{lib,log}/"${PN}"

	fowners -R opensearch-dashboards:opensearch-dashboards /usr/share/"${PN}"
	fowners -R opensearch-dashboards:opensearch-dashboards /var/{lib,log}/"${PN}"
	fowners -R opensearch-dashboards:opensearch-dashboards /etc/"${PN}"
}
