# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="table-postgres-${PV}"
DESCRIPTION="Table module for OpenSMTPD postgresql support."
HOMEPAGE="https://github.com/OpenSMTPD/table-postgres"
SRC_URI="https://github.com/OpenSMTPD/table-postgres/releases/download/${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-db/postgresql
!!mail-mta/opensmtpd-extras[opensmtpd_modules_table_postgres]"
RDEPEND="${DEPEND}"
