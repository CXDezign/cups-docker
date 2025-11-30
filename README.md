# Description

Run a CUPS on a server to share USB printers over network.
Built to be used with Raspberry Pi's.
Tested and confirmed working on:
- Raspberry Pi 3B+ (`arm/v7`)
- Raspberry Pi 4 (`arm64/v8`)
- Raspberry Pi 5 (`arm64/AArch64`)

Container packages available from Docker Hub
  - Docker Hub Image: `CXDezign/cups`

## Usage
Quick start with default parameters
```sh
docker run -d -p 631:631 --device /dev/bus/usb --name cups CXDezign/cups
```

Customizing your container
```sh
docker run -d --name cups \
    --restart unless-stopped \
    -p 631:631 \
    --device /dev/bus/usb \
    -e CUPSADMIN=admin \
    -e CUPSPASSWORD=password \
    -e TZ="Europe/Warsaw" \
    -v /etc/cups:/etc/cups \
    anujdatar/cups
```

### Parameters and defaults
- `port` Default cups network port `631:631`. Change not recommended unless you know what you're doing
- `device` -> Used to give docker access to USB printer. Default passes the whole USB bus `/dev/bus/usb`, in case you change the USB port on your device later. change to specific USB port if it will always be fixed, for eg. `/dev/bus/usb/001/005`.

#### Optional parameters
- `name` -> whatever you want to call your docker image. using `cups` in the example above.
- `volume` -> adds a persistent volume for CUPS config files if you need to migrate or start a new container with the same settings

Environment variables that can be changed to suit your needs, use the `-e` tag
| # | Parameter    | Default            | Type   | Description                       |
| - | ------------ | ------------------ | ------ | --------------------------------- |
| 1 | TZ           | "Europe/Warsaw"    | string | Time zone of your server          |
| 2 | CUPSADMIN    | admin              | string | Name of the admin user for server |
| 3 | CUPSPASSWORD | password           | string | Password for server admin         |

### docker-compose
```yaml
version: "3"
services:
    cups:
        image: CXDezign/cups
        container_name: cups
        restart: unless-stopped
        ports:
            - "631:631"
        devices:
            - /dev/bus/usb:/dev/bus/usb
        environment:
            - CUPSADMIN=admin
            - CUPSPASSWORD=password
            - TZ="Europe/Warsaw"
        volumes:
            - /etc/cups:/etc/cups
```

## CUPS Dashboard
Access the CUPS dashboard using the IP address of your server:

http://192.168.###.###:631
