#!/bin/bash -e

# as root

function enable_config_line() {
  local line="$1"
  local file="$2"
  if grep -q "$line" "$file"; then
    if grep -q "^#.*$line" "$file"; then
      sed -i "s/^#\($line\)/\1/" "$file"
    fi
  else
    echo "$line" | tee -a "$file" >/dev/null
  fi
}

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

CONFIG=/boot/firmware/config.txt

echo "Installing the GPIO poweroff detection overlay"
enable_config_line "dtoverlay=gpio-poweroff,gpiopin=2,input,active_low=17" $CONFIG

#echo "Installing PCF8563 real-time clock device overlay for SH-RPi v2"
#enable_config_line "dtoverlay=i2c-rtc,pcf8563" $CONFIG

#systemctl enable shrpid
