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

## Implementation Steps

The following work was completed in this repository:

1. Identified that the actual Git repository is `buildroot/` under `/home/hien/Pi4Buildroot`.
2. Reviewed the untracked Raspberry Pi 4 additions before making any Git changes.
3. Verified the custom overlay contents under `board/rpi4/rootfs_overlay/`.
4. Confirmed the added boot scripts:
   - `S42wifi` for Wi-Fi startup
   - `S98leddrv` for loading `gpio_led_drv.ko`
   - `S99distance` for starting `distance_app`
5. Reviewed the network configuration files:
   - `etc/network/interfaces`
   - `etc/modules-load.d/brcmfmac.conf`
   - `etc/wpa_supplicant.conf`
6. Verified the application artifacts placed into the image:
   - `distance_app`
   - `led_test`
   - `gpio_led_drv.ko`
7. Reviewed `build_app.sh`, which rebuilds `distance_app` from `~/Pi4App/main.c`, copies it into the overlay, and rebuilds Buildroot.
8. Added `PI4_UPDATE.md` to summarize the Raspberry Pi 4 custom update.
9. Committed the Pi4 overlay and helper script with commit:
   - `3b042bcc2b` `board/rpi4: add custom overlay and deployment notes`
10. Created SSH access for GitHub on this machine and configured the `personal` remote to:
   - `git@github.com:nguyenviethien/Pi4Buildroot.git`
11. Verified GitHub SSH authentication for the `nguyenviethien` account.
12. Attempted to push to remote `master`, but the remote already had an existing unrelated `master` branch history.
13. Added this `README_PI4.md` so the repository contains a clear description of:
   - what was added
   - what each app does
   - how boot-time startup works
   - how the image is rebuilt
14. Committed this README with commit:
   - `2f299580ed` `docs: add Pi4 custom README`
15. Pushed the custom work to the remote branch:
   - `pi4-buildroot`

## Git Result

- Remote repository: `git@github.com:nguyenviethien/Pi4Buildroot.git`
- Remote branch containing the custom work: `pi4-buildroot`
- The upstream-style Buildroot `README` file was intentionally left unchanged.
