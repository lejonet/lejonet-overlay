# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm systemd

DESCRIPTION="Wazuh Manager that takes care of analysing events and generating alerts"
HOMEPAGE="https://wazuh.com"
SRC_URI="https://packages.wazuh.com/4.x/yum/${P}-1.x86_64.rpm"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	newconfd "${FILESDIR}"/wazuh-manager.confd wazuh-manager
	newinitd "${FILESDIR}"/wazuh-manager.initd wazuh-manager
	systemd_dounit "${WORKDIR}"/usr/lib/systemd/system/wazuh-manager.service

	insinto /var
	doins -r "${WORKDIR}"/var/ossec
}
