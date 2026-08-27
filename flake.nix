{
  description = "NixOS config for a provisioning VM for Bodybytes devices (VirtualBox image)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    homemanager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homemanager, ... }:
    let
      system = "x86_64-linux";

      buildMemMiB = 16384;
      pkgsFor = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          segger-jlink.acceptLicense = true;
          permittedInsecurePackages = [
            "segger-jlink-qt4-874"
          ];
        };
        overlays = [
          (final: prev: {
            lkl = prev.lkl.overrideAttrs (old: {
              postPatch = (old.postPatch or "") + ''
                substituteInPlace tools/lkl/cptofs.c --replace-fail 'mem=100M' 'mem=${toString buildMemMiB}M'
              '';
            });
          })
        ];
      };

      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = pkgsFor;
        specialArgs = { };
        modules = [
          ./nix/configuration.nix
          homemanager.nixosModules.home-manager
          ({ pkgs, ... }: {
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
          })
        ];
      };

      virtualBoxOVA = nixpkgs.lib.overrideDerivation vm.config.system.build.virtualBoxOVA (old: {
        env = (old.env or { }) // {
          QEMU_OPTS = "-m ${toString buildMemMiB} -object memory-backend-memfd,id=mem,size=${toString buildMemMiB}M,share=on -machine memory-backend=mem";
        };
      });
    in
    {
      nixosConfigurations.bodybytes-vm = vm;

      packages.${system} = {
        default = virtualBoxOVA;
        inherit virtualBoxOVA;
      };
    };
}
