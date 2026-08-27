{ config, pkgs, ... }:
{

  # Desktop (KDE Plasma, Wayland)

  services.xserver = {
    enable = true;
    xkb.layout = "de";
  };

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };
  services.displayManager.defaultSession = "plasma";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  # Graphics

  hardware.graphics.enable = true;

  # Networking

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
      networkmanager-openconnect
      networkmanager-vpnc
      networkmanager-l2tp
      networkmanager-sstp
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Audio

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Segger J-Link

  services.udev.packages = with pkgs; [
    segger-jlink
  ];

  # Shell

  programs.zsh.enable = true;

  # Browser

  programs.firefox.enable = true;

}
