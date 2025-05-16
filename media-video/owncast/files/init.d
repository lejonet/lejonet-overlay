#!/sbin/openrc-run
# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

name="owncast daemon"
description=""
command=/usr/bin/owncast
command_args="${owncast_args}"
command_background=true
command_user="owncast:owncast"
pidfile="/run/${RC_SVCNAME}.pid"
start_stop_daemon_args="--chdir /var/lib/owncast"
