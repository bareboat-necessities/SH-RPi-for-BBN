#!/bin/bash -e

# as root

apt-get -y update
apt-get -y install pipx

mkdir -p "/opt/pipx/"

PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install shrpid

install -m 644 files/shrpid.service "/lib/systemd/system/"

#systemctl enable shrpid
