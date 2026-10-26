# OpenWrt for the GL.iNet GL-MT5000 (Brume 3)

This branch is OpenWrt main with GL-MT5000 support: GL.iNet's PR
[#24237](https://github.com/openwrt/openwrt/pull/24237) as reworked by dmsza,
plus fixes from review. It builds a plain OpenWrt image for any user; nothing
here is tied to a particular network.

**Status: community build, not tested on hardware by this branch.** Several
people report the underlying PR builds working as their main router. Keep a
way back to stock firmware (see below) before flashing.

## Building

Run the **Build GL-MT5000** workflow (Actions tab → Run workflow) on this
branch. Leave *profiles* empty for the base image (device support and LuCI),
or list extra profiles from `profiles/`, separated by spaces:

| Profile | Adds |
|---|---|
| `amneziawg` | AmneziaWG 3.1 kernel module, `awg`, LuCI page |
| `wireguard` | `wireguard-tools`, LuCI page |
| `adguardhome` | AdGuard Home |
| `avahi` | avahi daemon without D-Bus (mDNS, reflector) |
| `ddns-cloudflare` | Cloudflare dynamic DNS with the LuCI page |

To add your own, drop a `<name>.config` with `CONFIG_PACKAGE_...=y` lines in
`profiles/`. A profile may also carry a `<name>.feeds` file (extra feed lines)
and an executable `<name>.post-feeds.sh` run after the feeds are updated.

Packages from the official OpenWrt repositories that contain kernel modules
will not install on a custom build. Pick everything you need at build time.
To install packages from later builds of your fork on a flashed router, add a
repository secret `APK_SIGNING_KEY` with a persistent key:

```
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem
gh secret set APK_SIGNING_KEY < private-key.pem
```

## Installing

The build produces:

- `…-squashfs-sysupgrade.bin`: flash from GL.iNet's stock web interface
  (local upgrade, **keep settings off**) or with `sysupgrade -n` from OpenWrt.
- `…-squashfs-factory.bin`: raw kernel and rootfs for the stock U-Boot
  recovery page.
- `…-initramfs-kernel.bin`: runs from RAM, for testing without touching the
  eMMC (needs a serial console).

After flashing, the router is at `192.168.1.1` with LAN on `lan1`/`lan2`
and WAN on the third (2.5G SoC) port. Later OpenWrt sysupgrades keep settings.

Back to stock: hold reset while powering on, set your computer to
`192.168.1.2/24`, open `http://192.168.1.1` (the stock U-Boot recovery page
answers on a LAN port or the WAN port) and upload GL.iNet's firmware.

## Known limitations

- **Hardware flow offloading** with VLAN-filtering bridges is fixed by
  patch 795-13 in this branch but not yet verified on hardware. Software flow
  offloading is unaffected.
- VLAN interfaces (e.g. `lan1.100`) only work on ports in a VLAN-filtering
  bridge; use bridge VLAN filtering for trunks.
- Only one VLAN-filtering bridge is supported on the switch ports.
