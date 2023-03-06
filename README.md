Network UPS Tools (NUT) Server as a container

## Usage

```yaml
version: '3'

services:
  nut-server:
    container_name: nut-server
    image: docker-registry.timtrense.com/tim/nut-docker
    restart: unless-stopped
    volumes:
      # define you UPS'es here. For an example see that file in this project source
      - ./ups.conf:/etc/nut/ups.conf:ro
      # override this file with how to monitor your UPSes
      - ./upsmon.conf:/etc/nut/upsmon.conf:ro
      - shutdown-signal:/var/run/nut
  devices:
      # mount all devices on bus 001 to access a USB UPS
      - /dev/bus/usb/001:/dev/bus/usb/001
  shutdown-orchestrator:
    container_name: shutdown-orchestrator
    image: docker-registry.timtrense.com/tim/nut-docker:shutdown-orchestrator
    restart: unless-stopped
    volumes:
    - shutdown-signal:/var/run/nut
    # Register your shutdown scripts here (this would simply do smth. like `ssh root@host.docker.internal shutdown now`)
    - ./shutdown-command.sh:/bin/shutdown.d/01.sh:ro
    - /root/.ssh:/root/.ssh:ro
  extra_hosts:
      - "host.docker.internal:host-gateway"
volumes:
  shutdown-signal:
```

## Usage (Advanced)

```yaml
version: '3'

services:
  upsd:
    container_name: nut-server
    image: docker-registry.timtrense.com/tim/nut-docker
    restart: unless-stopped

    # if you want to open the NUT server to outside
    #ports:
    #  - 3493:3493

    volumes:
      # define you UPS'es here. For an example see that file in this project source
      - ./ups.conf:/etc/nut/ups.conf:ro
      # override this file with how to monitor your UPSes
      - ./upsmon.conf:/etc/nut/upsmon.conf:ro
      # override the default shutdown action (ie setting the flag below)
      - ./shutdowncmd.sh:/bin/shutdowncmd.sh:ro

      # if you opened your NUT server to the network, consider updating the credentials
      # otherwise you may want to react upon the following flag
      #- ./upsd.users:/etc/nut/upsd.users:ro
      - /var/run/nut/shutdownflag:/var/run/nut/shutdownflag
  # if you defined the credentials yourself, please uncomment:
  # environment:
  #     UPSD_UPDATE_RANDOM_PASSWORD: "false"
    devices:
      # mount all devices on bus 001 to access a USB UPS
      - /dev/bus/usb/001:/dev/bus/usb/001
```