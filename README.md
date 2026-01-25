# Description

Run Dockerised Printer server to share USB printers over the network. \
Built to be used with Raspberry Pi's. \
Tested and confirmed to be working on:
- Raspberry Pi 5 (`arm64/AArch64`)

# Usage
Use either **Docker Run** or **Docker Compose** to run the Docker image in a container with customised parameters.

## Parameters & Environment Variables
| Parameter         | Default                     | Description |
| ----------------- | --------------------------- | ----------- |
| `container_name`  | `cups`                      | Preferred Docker container name. |
| `devices`         | `/dev/bus/usb:/dev/bus/usb` | Add host device (USB printer) to container. Default passes the whole USB bus in case the USB port on your device changes. Change to a fixed USB port if it will remain unchanged, example: `/dev/bus/usb/001/005`. |
| `volumes`         | `cups`                      | Persistent Docker container volume for CUPS configuration files (migration or backup purposes). |
| `ports`           | `631`                       | CUPS network port. |
| `USERNAME`        | `username`                  | Environment username. |
| `PASSWORD`        | `password`                  | Environment password. |
| `TIMEZONE`        | `Europe/Warsaw`             | Environment timezone. Use your preferred [TZ identifier](https://wikipedia.org/wiki/List_of_tz_database_time_zones#List). |

## Docker Compose
```yaml
services:
    cups:
        image: cxdezign/cups
        container_name: cups
        restart: unless-stopped
        ports:
            - 631:631
        devices:
            - /dev/bus/usb:/dev/bus/usb
        environment:
            - USERNAME="username"
            - PASSWORD="password"
            - TIMEZONE="Europe/Warsaw"
        volumes:
            - /etc/cups:/etc/cups
```
