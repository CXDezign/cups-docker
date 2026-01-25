#!/bin/bash -ex

# Timezone Configuration
ln -fs /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

cupsd -f &
CUPSID=$!
# Unix Socket Wait
for _ in {1..100}; do
    if [ -S /var/run/cups/cups.sock ]; then break; fi
    sleep 0.1
done
# TCP Port Wait
for _ in {1..50}; do
    if ss -ltn | grep -q ':631 '; then break; fi
    sleep 0.1
done

# CUPS Configuration
if [[ ! -f /etc/cups/.initialized ]]; then
    cupsctl --remote-admin --remote-any --share-printers
    touch /etc/cups/.initialized
fi

grep -xF 'ServerAlias *' /etc/cups/cupsd.conf || \
    echo 'ServerAlias *' >> /etc/cups/cupsd.conf
grep -xF 'DefaultEncryption Never' /etc/cups/cupsd.conf || \
    echo 'DefaultEncryption Never' >> /etc/cups/cupsd.conf

# User Configuration
if ! getent shadow "$USERNAME" > /dev/null; then
    useradd -r -G lpadmin -M "$USERNAME"
    echo "$USERNAME":"$PASSWORD" | chpasswd
fi

# Restore Default Configurations
[[ -f /etc/cups/cupsd.conf ]] || cp -rpn /etc/cups.bak/* /etc/cups/

# Execute
wait "$CUPSID"
