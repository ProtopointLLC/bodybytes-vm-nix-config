# bodybytes-vm-nix-config

NixOS config for a provisioning VM for Bodybytes devices

This flake builds a NixOS VirtualBox appliance (`.ova`) meant to run as a single VM on Intel x86_64 with one disk. It ships KDE Plasma (Wayland/SDDM), NetworkManager, avahi, pipewire audio, a Segger J-Link udev rule, Firefox, an SSH server, and a `bodybytes` user with home-manager–managed zsh and VS Code.

## Build

Requires Nix with flakes enabled (`experimental-features = nix-command flakes` in `nix.conf`, or pass `--extra-experimental-features 'nix-command flakes'`).

```sh
nix build .#virtualBoxOVA
```

The resulting `.ova` appliance is written to `result/` (as `result/nix-support/hydra-build-products` lists it) and can be imported directly into VirtualBox (`File > Import Appliance`).

### Host requirement: VirtualBox Extension Pack

The appliance is configured for an **xHCI (USB 3.0)** controller, which VirtualBox only provides with the [Oracle VM VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads). Install it on the host before importing, or the VM will refuse to start. The pack must match the host's VirtualBox version.

## Login

- User: `bodybytes` / password: `bodybytes` (change after first login)
- SSH and the KDE desktop session use the same account.
- An authorized SSH public key for `bodybytes` is baked in via `nix/configuration.nix` (`users.users.bodybytes.openssh.authorizedKeys.keys`); the matching private key is kept outside this repo.

## Notes

- No `hardware-configuration.nix` is needed. `virtualbox-image.nix` (imported from upstream nixpkgs) already declares the disk's filesystems, swap, and bootloader device, and NixOS's default initrd module set covers the AHCI/USB storage controllers VirtualBox emulates — that file only exists for machine-specific detection on a real install, which doesn't apply to a from-scratch appliance image.
- **USB is xHCI-only, on purpose.** The J-Link is a full-speed (12 Mbit/s) device, and an EHCI controller hands full-speed devices to its companion OHCI - so the module's default of `usb = "on"; usbehci = "on"` leaves the debugger on emulated OHCI, where every transfer waits on a 1 ms frame boundary. JTAG flashing is latency-bound rather than bandwidth-bound (roughly eight USB round trips per 32-bit word), so this is worth about 19x: loading a 484 KB U-Boot measured 0.12 KiB/s on OHCI and 0.9 KiB/s on xHCI, against 2.3 KiB/s with the adapter on a native port. Do not "also" enable OHCI or EHCI to be safe - that puts the device back on the slow controller.
- VirtualBox guest additions (`virtualisation.virtualbox.guest.enable`) are turned on automatically by `virtualbox-image.nix`, so clipboard sharing, seamless mode, and display resizing work out of the box.
