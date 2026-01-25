# Docker CUPS
## Description
Run Dockerised Printer server to share USB printers over the network. \
Built to be used with Raspberry Pi's. \
Tested and confirmed to be working on:
- Raspberry Pi 5 (`arm64/AArch64`)

## Usage
1. Clone this repository:
```bash
git clone https://github.com/CXDezign/docker-cups.git
```
2. Build the Docker image:
```bash
docker build -t docker-cups .
```
3. Create a `docker-compose.yml` file with the following content, adjusting parameters as needed:
```yaml
services:
    cups:
        container_name: cups
        image: docker-cups
        restart: unless-stopped
        ports:
            - 631:631
        volumes:
            - /etc/cups:/etc/cups
        devices:
            - /dev/bus/usb:/dev/bus/usb
        environment:
            - USERNAME="username"
            - PASSWORD="password"
            - TIMEZONE="Europe/Warsaw"
```
4. Use **Docker Compose** to run the Docker image in a container.
```bash
docker-compose up -d
```

## Configuration
Configure the `docker-compose.yml` file accordingly.
| Parameter         | Default                     | Description |
| ----------------- | --------------------------- | ----------- |
| `container_name`  | `cups`                      | Preferred Docker container name. |
| `devices`         | `/dev/bus/usb:/dev/bus/usb` | Add host device (USB printer) to container. Default passes the whole USB bus in case the USB port on your device to a fixed USB port if it will remain unchanged, example: `/dev/bus/usb/001/005`. |
| `volumes`         | `/etc/cups`                 | Persistent Docker volume for CUPS configuration files (Persistence, migration, or backup purposes). |
| `ports`           | `631`                       | CUPS network port. |
| `USERNAME`        | `username`                  | Environment username. |
| `PASSWORD`        | `password`                  | Environment password. |
| `TIMEZONE`        | `Europe/Warsaw`             | Environment timezone. Use your preferred [TZ identifier](https://wikipedia.org/wiki/List_of_tz_database_time_zones#List). |

## Access
Access the CUPS dashboard using the IP address of your server: \
http://192.168.###.###:631
