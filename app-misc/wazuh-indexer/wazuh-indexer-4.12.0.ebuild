# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles

DESCRIPTION="Open source distributed and RESTful search engine, Wazuh edition."
HOMEPAGE="https://wazuh.com/"
SRC_URI="https://packages.wazuh.com/4.x/apt/pool/main/w/${PN}/${PN}_${PV}-1_amd64.deb"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/opensearch
	acct-user/opensearch"
RDEPEND="${DEPEND}
	sys-libs/zlib
	virtual/jre:21"

QA_PREBUILT="/usr/share/wazuh-indexer/.*"
QA_PRESTRIPPED="/usr/share/wazuh-indexer/jdk/lib/.*
/usr/share/wazuh-indexer/jdk/bin/.*"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}"/data.tar.gz
}

src_install() {
	insopts -m 0640
	insinto /etc/
	doins -r "${WORKDIR}/etc/${PN}"

	fowners -R root:opensearch /etc/"${PN}"

	insinto /usr/share/
	doins -r "${WORKDIR}/usr/share/${PN}"

	fperms -R og+x /usr/share/"${PN}"/bin
	fperms -R og+x /usr/share/"${PN}"/jdk/bin
	fperms -R og+x /usr/share/"${PN}"/performance-analyzer-rca/bin
	fperms og+x /usr/share/"${PN}"/plugins/opensearch-security/tools/*.sh

	keepdir /var/{lib,log}/"${PN}"
	fowners opensearch:opensearch /var/{lib,log}/"${PN}"
	fperms 0750 /var/{lib,log}/"${PN}"

	insinto /etc/default
	doins "${WORKDIR}"/etc/default/wazuh-indexer

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${PN}.sysctl.d" "${PN}".conf

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newtmpfiles "${FILESDIR}/${PN}.tmpfiles.d" "${PN}".conf
}

pkg_postinst() {
	tmpfiles_process
}
