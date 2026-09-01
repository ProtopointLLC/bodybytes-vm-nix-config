{ modulesPath, config, pkgs, lib, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/virtualbox-image.nix")
    ./packages.nix
    ./services.nix
    ./apps/vscode.nix
    ./apps/zsh.nix
  ];

  # VirtualBox appliance

  virtualbox.vmName = "Bodybytes VM";
  virtualbox.memorySize = 8192;
  virtualbox.params = {
    cpus = 4;
    clipboard = "bidirectional";
    draganddrop = "bidirectional";
    vram = 128;
    natpf1 = "guestssh,tcp,,2222,,22";
    usb = "off";
    usbehci = "off";
    usbxhci = "on";
  };

  # Networking

  networking.hostName = "bodybytes-vm";

  # Localization

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  console = {
    keyMap = "us";
  };

  # Users

  users.users.bodybytes = {
    uid = 1000;
    initialPassword = "bodybytes";
    isNormalUser = true;
    description = "Bodybytes";
    shell = pkgs.zsh;
    home = "/home/bodybytes";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjfsrdnO+BOAm884MCwoS7z4pjLaJmnpS6AqpKJUGY7 bodybytes-vm"
    ];
  };

  # Security

  security.polkit = {
    enable = true;
  };

  # Misc

  nix.settings.download-buffer-size = 524288000;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
  '';

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment? yes
  home-manager.users.bodybytes.home.stateVersion = "26.05";
}
