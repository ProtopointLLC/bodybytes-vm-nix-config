# bodybytes-vm-nix-config

NixOS config for a provisioning VM for Bodybytes devices

This flake builds a NixOS VirtualBox appliance (`.ova`) meant to run as a single VM on Intel x86_64 with one disk. It ships KDE Plasma (Wayland/SDDM), NetworkManager, avahi, pipewire audio, a Segger J-Link udev rule, Firefox, an SSH server, and a `bodybytes` user with home-manager–managed zsh and VS Code.

## Build

Requires Nix with flakes enabled (`experimental-features = nix-command flakes` in `nix.conf`, or pass `--extra-experimental-features 'nix-command flakes'`).

```sh
nix build .#virtualBoxOVA
```

The resulting `.ova` appliance is written to `result/` (as `result/nix-support/hydra-build-products` lists it) and can be imported directly into VirtualBox (`File > Import Appliance`).

## Login

- User: `bodybytes` / password: `bodybytes` (change after first login)
- SSH and the KDE desktop session use the same account.

## Notes

- No `hardware-configuration.nix` is needed. `virtualbox-image.nix` (imported from upstream nixpkgs) already declares the disk's filesystems, swap, and bootloader device, and NixOS's default initrd module set covers the AHCI/USB storage controllers VirtualBox emulates — that file only exists for machine-specific detection on a real install, which doesn't apply to a from-scratch appliance image.
- VirtualBox guest additions (`virtualisation.virtualbox.guest.enable`) are turned on automatically by `virtualbox-image.nix`, so clipboard sharing, seamless mode, and display resizing work out of the box.
