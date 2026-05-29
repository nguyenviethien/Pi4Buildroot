# Pi4 Custom Buildroot Notes

This repository contains a custom Raspberry Pi 4 overlay on top of upstream Buildroot.

## What Was Added

- `board/rpi4/rootfs_overlay/`
  - Custom root filesystem overlay for Raspberry Pi 4.
- `build_app.sh`
  - Helper script to rebuild `distance_app` from `~/Pi4App/main.c`, copy it into the overlay, and rebuild Buildroot.
- `PI4_UPDATE.md`
  - Short change log for the custom Pi4 additions.

## Applications And Components

### 1. `distance_app`

Path:
- `board/rpi4/rootfs_overlay/root/distance_app`

Purpose:
- Prebuilt AArch64 application placed into the target root filesystem.
- Embedded strings show GPIO sysfs access and distance measurement output in centimeters.

Boot behavior:
- Started automatically by `board/rpi4/rootfs_overlay/etc/init.d/S99distance`.

### 2. `led_test`

Path:
- `board/rpi4/rootfs_overlay/root/led_test`

Purpose:
- Prebuilt AArch64 user-space test application for GPIO-based LED control.

### 3. `gpio_led_drv.ko`

Path:
- `board/rpi4/rootfs_overlay/root/gpio_led_drv.ko`

Purpose:
- Prebuilt AArch64 kernel module implementing a simple GPIO LED driver.

Boot behavior:
- Loaded automatically by `board/rpi4/rootfs_overlay/etc/init.d/S98leddrv`.

## Network Setup

The overlay includes Wi-Fi boot configuration:

- `board/rpi4/rootfs_overlay/etc/init.d/S42wifi`
  - Loads `brcmfmac`, brings up `wlan0`, starts `wpa_supplicant`, and requests DHCP.
- `board/rpi4/rootfs_overlay/etc/modules-load.d/brcmfmac.conf`
  - Requests loading of the Broadcom Wi-Fi driver.
- `board/rpi4/rootfs_overlay/etc/network/interfaces`
  - Keeps `eth0` on DHCP and defines `wlan0` as manual.
- `board/rpi4/rootfs_overlay/etc/wpa_supplicant.conf`
  - Contains Wi-Fi country code and WPA-PSK configuration.

## Boot Sequence

With this overlay enabled in Buildroot, the target image is expected to:

1. initialize Wi-Fi,
2. connect to the configured network,
3. load the LED kernel driver,
4. start `distance_app`.

## Build Flow

Manual flow:

```bash
cd ~/Pi4Buildroot/buildroot
make
```

Helper flow for the distance application:

```bash
cd ~/Pi4Buildroot/buildroot
./build_app.sh
```

## Important Notes

- The repository currently includes prebuilt binaries and a prebuilt kernel module.
- The Wi-Fi configuration file contains plain-text credentials and should be reviewed before wider sharing.
- The custom overlay still depends on local Buildroot configuration selecting `board/rpi4/rootfs_overlay` as the rootfs overlay path.
