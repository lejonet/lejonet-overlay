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
QA_PRESTRIPPED="/var/ossec/bin/.*
/var/ossec/framework/python/lib/python3.10/site-packages/grpc/_cython/cygrpc.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy.libs/libquadmath-96973f99.so.0.0.0
/var/ossec/framework/python/lib/python3.10/site-packages/numpy.libs/libgfortran-040039e1.so.5.0.0
/var/ossec/lib/.*
/var/ossec/active-response/bin/.*
/var/ossec/framework/python/bin/python3.10
/var/ossec/framework/python/lib/libpython3.so
/var/ossec/framework/python/lib/libpython3.10.so.1.0
/var/ossec/framework/python/lib/python3.10/site-packages/_cffi_backend.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/yarl/_quoting_c.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/markupsafe/_speedups.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/pyarrow/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/multidict/_multidict.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/lazy_object_proxy/cext.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/rpds/rpds.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/frozenlist/_frozenlist.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/sqlalchemy/cyextension/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/psutil/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/cryptography/hazmat/bindings/_rust.abi3.so
/var/ossec/framework/python/lib/python3.10/site-packages/greenlet/_greenlet.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/greenlet/tests/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/grpc/_cython/cygrpc.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/uvloop/loop.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy.libs/libquadmath-96973f99.so.0.0.0
/var/ossec/framework/python/lib/python3.10/site-packages/numpy.libs/libgfortran-040039e1.so.5.0.0
/var/ossec/framework/python/lib/python3.10/site-packages/numpy.libs/libopenblas64_p-r0-0cf96a72.3.23.dev.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/linalg/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/random/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/random/bit_generator.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/random/_mt19937.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/random/lib/libnpyrandom.a
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/fft/_pocketfft_internal.cpython-310-x86_64-linux-gnu.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/core/.*.so
/var/ossec/framework/python/lib/python3.10/site-packages/numpy/core/lib/libnpymath.a
/var/ossec/framework/python/lib/python3.10/lib-dynload/.*.so
/var/ossec/framework/python/lib/python3.10/config-3.10-x86_64-linux-gnu/python.o
/var/ossec/framework/python/lib/python3.10/config-3.10-x86_64-linux-gnu/libpython3.10.a
/var/ossec/lib/.*.so.*"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}"/data.tar.xz
}

src_install() {
	newconfd "${FILESDIR}"/wazuh-manager.confd wazuh-manager
	newinitd "${FILESDIR}"/wazuh-manager.initd wazuh-manager
	systemd_dounit "${WORKDIR}"/usr/lib/systemd/system/wazuh-manager.service
	newenvd "${FILESDIR}"/wazuh-manager.envd 99wazuh-manager

	dodir /var/ossec
	cp -ar "${WORKDIR}"/var/ossec/ "${ED}"/var/ || die "Failed to copy /var/ossec"

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
