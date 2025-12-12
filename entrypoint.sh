#!/bin/bash -ex

if [ $(grep -ci $USERNAME /etc/shadow) -eq 0 ]; then
    useradd -r -G lpadmin -M $USERNAME

    # Add Username:Password
    echo $USERNAME:$PASSWORD | chpasswd

    # Add Timezone
    ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
fi

# Restore default CUPS config if empty
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /etc/cups.bak/* /etc/cups/
fi

exec /usr/sbin/cupsd -f
