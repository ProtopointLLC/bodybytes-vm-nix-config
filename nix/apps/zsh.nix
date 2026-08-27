{ config, pkgs, lib, ... }:
{
  environment.pathsToLink = [ "/share/zsh" ];

  # Glyphs used by the powerlevel10k prompt
  fonts.packages = [ pkgs.nerd-fonts.hack ];

  home-manager.users.bodybytes.programs.zsh = {
    enable = true;

    sessionVariables = {
      EDITOR = "nano";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./.;
        file = "p10k-config.zsh";
      }
    ];

    "oh-my-zsh" = {
      enable = true;
      plugins = [
        "systemd"
        "colored-man-pages"
        "z"
      ];
    };
  };
}
