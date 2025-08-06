# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch, Wazuh edition"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://packages.wazuh.com/4.x/yum/filebeat-${PV}-1.x86_64.rpm -> ${P}.rpm"

LICENSE="Apache-2.0 BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	rpm_unpack ${A}

	unpack "${FILESDIR}"/wazuh-filebeat-0.4.tar.gz
}

src_install() {
	newconfd "${FILESDIR}"/filebeat.confd filebeat
	newinitd "${FILESDIR}"/filebeat.initd filebeat
	insinto /usr/lib/systemd/system
	doins "${WORKDIR}"/lib/systemd/system/filebeat.service

	dobin "${WORKDIR}"/usr/bin/filebeat

	insinto /usr/share/
	doins -r "${WORKDIR}"/usr/share/filebeat

	insinto /etc/
	doins -r "${WORKDIR}"/etc/filebeat

	insinto /etc/filebeat
	doins "${FILESDIR}"/wazuh-template.json
	newins "${FILESDIR}"/wazuh-filebeat.yml filebeat.yml

	insinto /usr/share/filebeat/module
	doins -r "${WORKDIR}"/wazuh
}
