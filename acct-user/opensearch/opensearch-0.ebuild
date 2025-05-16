# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Opensearch program user"
ACCT_USER_ID=541
ACCT_USER_HOME=/usr/share/opensearch
ACCT_USER_HOME_PERMS=0755
ACCT_USER_GROUPS=( opensearch )
acct-user_add_deps
