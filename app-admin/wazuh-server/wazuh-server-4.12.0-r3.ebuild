# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wazuh server is composed of Wazuh Manager and Wazuh Filebeat"
HOMEPAGE="https://wazuh.com"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="=app-admin/wazuh-manager-${PVR}
=app-admin/wazuh-filebeat-7.10.2-r1"
RDEPEND="${DEPEND}"
