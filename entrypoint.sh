#!/bin/bash -ex

# Timezone Configuration
ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# Stop Previous CUPS Instance
if [ -f /var/run/cups/cupsd.pid ]; then
    kill "$(cat /var/run/cups/cupsd.pid)" 2>/dev/null || true
    timeout 5 sh -c 'while [ -e /var/run/cups/cupsd.pid ]; do sleep .1; done'
    kill -9 "$(cat /var/run/cups/cupsd.pid)" 2>/dev/null || true
fi
rm -f /var/run/cups/*

# CUPS Temporary Start
/usr/sbin/cupsd &
FIRST_PID=$!

# PID Wait
while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 0.5; done

# CUPS Configuration
cupsctl --remote-admin --remote-any --share-printers
grep -xF 'ServerAlias *' /etc/cups/cupsd.conf || \
    echo 'ServerAlias *' >> /etc/cups/cupsd.conf
grep -xF 'DefaultEncryption Never' /etc/cups/cupsd.conf || \
    echo 'DefaultEncryption Never' >> /etc/cups/cupsd.conf

# User Configuration
if ! getent shadow "$USERNAME" > /dev/null; then
    useradd -r -G lpadmin -M $USERNAME
    echo $USERNAME:$PASSWORD | chpasswd
fi

# Restore Default Configurations
[[ -f /etc/cups/cupsd.conf ]] || cp -rpn /etc/cups.bak/* /etc/cups/

# Kill Temporary Instance
kill $FIRST_PID || true

# Execute
/usr/sbin/cupsd -f
