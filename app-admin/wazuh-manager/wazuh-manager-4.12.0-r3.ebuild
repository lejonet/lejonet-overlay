# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Wazuh Manager that takes care of analysing events and generating alerts"
HOMEPAGE="https://wazuh.com"
SRC_URI="https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-manager/${PN}_${PV}-1_amd64.deb"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-user/wazuh
acct-group/wazuh"
RDEPEND="${DEPEND}"

QA_PREBUILT="var/ossec/*"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}"/data.tar.xz
}

src_install() {
	newconfd "${FILESDIR}"/wazuh-manager.confd wazuh-manager
	newinitd "${FILESDIR}"/wazuh-manager.initd wazuh-manager
	systemd_dounit "${WORKDIR}"/usr/lib/systemd/system/wazuh-manager.service

	cp -ar "${WORKDIR}"/var/ossec "${D}"/var/ || die "Failed to copy /var/ossec"

	keepdir /var/ossec/.ssh
	keepdir /var/ossec/api/configuration/security
	keepdir /var/ossec/api/configuration/ssl
	keepdir /var/ossec/backup
	keepdir /var/ossec/backup/agents
	keepdir /var/ossec/backup/db
	keepdir /var/ossec/backup/shared
	keepdir /var/ossec/logs
	keepdir /var/ossec/logs/alerts
	keepdir /var/ossec/logs/api
	keepdir /var/ossec/logs/archives
	keepdir /var/ossec/logs/cluster
	keepdir /var/ossec/logs/firewall
	keepdir /var/ossec/logs/wazuh
	keepdir /var/ossec/packages_files/manager_installation_scripts/sca/suse/12
	keepdir /var/ossec/queue/agentless
	keepdir /var/ossec/queue/alerts
	keepdir /var/ossec/queue/cluster
	keepdir /var/ossec/queue/db
	keepdir /var/ossec/queue/diff
	keepdir /var/ossec/queue/fim
	keepdir /var/ossec/queue/fim/db
	keepdir /var/ossec/queue/fts
	keepdir /var/ossec/queue/indexer
	keepdir /var/ossec/queue/keystore
	keepdir /var/ossec/queue/logcollector
	keepdir /var/ossec/queue/rids
	keepdir /var/ossec/queue/router
	keepdir /var/ossec/queue/sockets
	keepdir /var/ossec/queue/syscollector/db
	keepdir /var/ossec/queue/tasks
	keepdir /var/ossec/queue/vd
	keepdir /var/ossec/stats
	keepdir /var/ossec/var/download
	keepdir /var/ossec/var/multigroups
	keepdir /var/ossec/var/run
	keepdir /var/ossec/var/upgrade
	keepdir /var/ossec/var/wodles

	fowners wazuh:wazuh -R /var/ossec
}
