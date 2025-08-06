# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch, Wazuh edition"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://packages.wazuh.com/4.x/apt/pool/main/f/filebeat/filebeat_${PV}-1_amd64.deb"
S="${WORKDIR}"

LICENSE="Apache-2.0 BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

QA_PRESTRIPPED="/usr/share/filebeat/bin/filebeat
/usr/share/filebeat/bin/filebeat-god"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}"/data.tar.gz

	unpack "${FILESDIR}"/wazuh-filebeat-0.4.tar.gz
	unpack "${FILESDIR}"/wazuh-template.json.gz
}

src_install() {
	newconfd "${FILESDIR}"/filebeat.confd filebeat
	newinitd "${FILESDIR}"/filebeat.initd filebeat
	systemd_dounit "${WORKDIR}"/lib/systemd/system/filebeat.service

	dobin "${WORKDIR}"/usr/bin/filebeat

	insinto /usr/share/
	doins -r "${WORKDIR}"/usr/share/filebeat

	insinto /etc/
	doins -r "${WORKDIR}"/etc/filebeat

	insinto /etc/filebeat
	doins "${WORKDIR}"/wazuh-template.json
	newins "${FILESDIR}"/wazuh-filebeat.yml filebeat.yml

	insinto /usr/share/filebeat/module
	doins -r "${WORKDIR}"/wazuh
}
