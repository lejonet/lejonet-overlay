# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Addons for the opensmtpd mail daemon"
HOMEPAGE="https://github.com/OpenSMTPD/OpenSMTPD-extras"
SRC_URI="https://github.com/OpenSMTPD/OpenSMTPD-extras/releases/download/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
OPENSMTPD_MODULES_TABLE="ldap mysql postgres redis socketmap passwd python sqlite stub"
OPENSMTPD_MODULES_QUEUE="python ram stub null"
OPENSMTPD_MODULES_FILTER="void trace stub monkey"
OPENSMTPD_MODULES_SCHEDULER="ram stub python"

for mod in ${OPENSMTPD_MODULES_TABLE}; do
	IUSE="${IUSE} opensmtpd_modules_table_${mod}"
done

for mod in ${OPENSMTPD_MODULES_QUEUE}; do
	IUSE="${IUSE} opensmtpd_modules_queue_${mod}"
done

for mod in ${OPENSMTPD_MODULES_FILTER}; do
	IUSE="${IUSE} opensmtpd_modules_filter_${mod}"
done

for mod in ${OPENSMTPD_MODULES_SCHEDULER}; do
	IUSE="${IUSE} opensmtpd_modules_scheduler_${mod}"
done

DEPEND="
opensmtpd_modules_table_postgres? ( dev-db/postgresql:* )
opensmtpd_modules_table_mysql? ( dev-db/mysql:* )
opensmtpd_modules_table_redis? ( dev-db/redis:* )
opensmtpd_modules_table_sqlite? ( dev-db/sqlite:* )
opensmtpd_modules_table_python? ( dev-lang/python:* )
opensmtpd_modules_queue_python? ( dev-lang/python:* )
opensmtpd_modules_scheduler_python? ( dev-lang/python:* )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-build/automake-1.13
dev-build/autoconf
dev-build/libtool
virtual/pkgconfig
"

src_configure() {
	local myconf=()

	for mod in ${OPENSMTPD_MODULES_TABLE}; do
		if use opensmtpd_modules_table_${mod}; then
			myconf+=( --with-table-${mod} )
		fi
	done

	for mod in ${OPENSMTPD_MODULES_QUEUE}; do
		if use opensmtpd_modules_queue_${mod}; then
			myconf+=( --with-queue-${mod} )
		fi
	done

	for mod in ${OPENSMTPD_MODULES_FILTER}; do
		if use opensmtpd_modules_filter_${mod}; then
			myconf+=( --with-filter-${mod} )
		fi
	done

	for mod in ${OPENSMTPD_MODULES_scheduler}; do
		if use opensmtpd_modules_scheduler_${mod}; then
			myconf+=( --with-scheduler-${mod} )
		fi
	done

	./configure \
		--with-user-smtpd=smtpd \
		--with-pie \
		--libexecdir=/usr/libexec \
		--mandir=/usr/share/man \
		"${myconf[@]}" || die "configure failed"
}
