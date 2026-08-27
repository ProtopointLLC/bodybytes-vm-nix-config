{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # General
    bash
    coreutils
    screen
    # Editors
    nano
    vim
    # Networking
    git
    wget
    curl
    avahi
    # Compression
    zip
    unzip
    p7zip
    # File handling
    file
    # Hardware tooling
    segger-jlink
    usbutils
    util-linux
    # GPU diagnostics
    mesa-demos
    clinfo
    vulkan-tools
  ];

  environment.pathsToLink = [
    "/share/icons"
    "/share/mime"
  ];
}
