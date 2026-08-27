{ config, pkgs, ... }:
{
  home-manager.users.bodybytes.programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        editorconfig.editorconfig
        eamodio.gitlens
        mkhl.direnv
        vscode-icons-team.vscode-icons
      ];
    };

    mutableExtensionsDir = false;
  };
}
