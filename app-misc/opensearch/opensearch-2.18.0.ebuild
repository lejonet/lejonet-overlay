# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles

DESCRIPTION="Open source distributed and RESTful search engine."
HOMEPAGE="https://opensearch.org/"
SRC_URI="https://artifacts.opensearch.org/releases/bundle/${PN}/${PV}/${P}-linux-x64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/opensearch
	acct-user/opensearch"
RDEPEND="${DEPEND}
	sys-libs/zlib
	virtual/jre:21"

src_prepare() {
	default

	rm -rf jdk || die
	sed -i -e "s:logs/:${EPREFIX}/var/log/${PN}/:g" config/jvm.options || die "Unable to set Opensearch log location"
	# opensearch-env sets the envvar for the config location if not specified elsewhere;
	# certain utilities try and source this.
	sed -i "s:OPENSEARCH_PATH_CONF=\`cd \"\$OPENSEARCH_PATH_CONF\"; pwd\`:OPENSEARCH_PATH_CONF=\"${EPREFIX}/etc/${PN}\":" \
		bin/opensearch-env || die "Unable to set Opensearch config directory"
	rm LICENSE.txt NOTICE.txt || die
	rmdir logs || die
}

src_install() {
	keepdir /etc/${PN}

	insinto /etc/${PN}
	doins -r config/.
	rm -r config || die

	fowners -R root:${PN} /etc/${PN}
	fperms -R 2750 /etc/${PN}

	insinto /usr/share/${PN}
	doins -r .

	fperms -R +x /usr/share/${PN}/bin

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	fperms 0750 /var/{lib,log}/${PN}

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${PN}.sysctl.d" ${PN}.conf

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles.d ${PN}.conf
}
