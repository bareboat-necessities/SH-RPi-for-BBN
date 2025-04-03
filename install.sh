#!/bin/bash -e

# as root

apt-get -y update
apt-get -y install pipx

mkdir -p "/opt/pipx/"

# see: https://pypi.org/project/shrpid/
PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install shrpid

bash -c 'cat << EOF > /lib/systemd/system/shrpid.service
[Unit]
Description=SH-RPi Daemon
After=syslog.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/local/bin/shrpid -s /var/run/shrpid.sock

[Install]
WantedBy=multi-user.target
EOF'

#systemctl enable shrpid
