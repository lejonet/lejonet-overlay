# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Wazuh agent and endpoint protection."
HOMEPAGE="https://wazuh.com"
SRC_URI="https://packages.wazuh.com/4.x/apt/pool/main/w/${PN}/${PN}_${PV}-1_amd64.deb"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-user/wazuh
acct-group/wazuh"
RDEPEND="${DEPEND}"

QA_PREBUILT="var/ossec/.*"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}"/data.tar.gz
}

src_install() {
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	newenvd "${FILESDIR}"/wazuh-agent.envd 99wazuh-agent

	dodir /var/ossec
	cp -ar "${WORKDIR}"/var/ossec/ "${ED}"/var/ || die "Failed to copy /var/ossec"

	keepdir /var/ossec/var/{incoming,run,upgrade,wodles}
	keepdir /var/ossec/logs/wazuh
	keepdir /var/ossec/tmp
	keepdir /var/ossec/backup
	keepdir /var/ossec/.ssh
	keepdir /var/ossec/queue/{alerts,diff,logcollector,rids,sockets}
	keepdir /var/ossec/queue/{fim,syscollector}/db

	fowners -R wazuh:wazuh /var/ossec
}
