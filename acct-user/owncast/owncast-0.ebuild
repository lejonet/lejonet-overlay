# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="${PN} program user"
ACCT_USER_ID=532
ACCT_USER_GROUPS=( owncast )

acct-user_add_deps
