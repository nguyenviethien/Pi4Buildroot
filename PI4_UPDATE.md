# Raspberry Pi 4 Custom Update

This repository currently includes a Raspberry Pi 4 root filesystem overlay and a helper build script for deploying a custom application bundle.

## Added Files

- `board/rpi4/rootfs_overlay/etc/init.d/S42wifi`
  - Loads `brcmfmac`, brings up `wlan0`, starts `wpa_supplicant`, and requests DHCP with `udhcpc`.
- `board/rpi4/rootfs_overlay/etc/init.d/S98leddrv`
  - Loads `/root/gpio_led_drv.ko` during boot if the module is not already active.
- `board/rpi4/rootfs_overlay/etc/init.d/S99distance`
  - Starts `/root/distance_app` in the background during boot.
- `board/rpi4/rootfs_overlay/etc/modules-load.d/brcmfmac.conf`
  - Requests automatic loading of the Broadcom Wi-Fi driver.
- `board/rpi4/rootfs_overlay/etc/network/interfaces`
  - Keeps `eth0` on DHCP and defines `wlan0` as a manual interface.
- `board/rpi4/rootfs_overlay/etc/wpa_supplicant.conf`
  - Stores the Wi-Fi country code and WPA-PSK network credentials used by the boot script.
- `board/rpi4/rootfs_overlay/root/distance_app`
  - Prebuilt AArch64 user-space binary. Embedded strings indicate GPIO sysfs access and distance measurement output.
- `board/rpi4/rootfs_overlay/root/led_test`
  - Prebuilt AArch64 user-space binary. Embedded strings indicate GPIO sysfs access for LED testing.
- `board/rpi4/rootfs_overlay/root/gpio_led_drv.ko`
  - Prebuilt AArch64 kernel module exposing a simple GPIO LED driver.
- `build_app.sh`
  - Rebuilds `distance_app` from `~/Pi4App/main.c`, copies it into the overlay, and rebuilds Buildroot output.

## Boot-Time Behavior

The overlay is set up so that the target image can:

1. load the Raspberry Pi Wi-Fi driver,
2. connect to the configured WPA network,
3. insert the custom LED kernel module,
4. start the distance application automatically.

## Current Constraints

- The overlay contains plain-text Wi-Fi credentials in `wpa_supplicant.conf`.
- `distance_app`, `led_test`, and `gpio_led_drv.ko` are committed as prebuilt binaries, not source code.
- `build_app.sh` only rebuilds `distance_app`; it does not rebuild `led_test` or `gpio_led_drv.ko`.
- No Buildroot defconfig or board integration file was added in this change set, so applying the overlay still depends on local Buildroot configuration pointing to `board/rpi4/rootfs_overlay`.
