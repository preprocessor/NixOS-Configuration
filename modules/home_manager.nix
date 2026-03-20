{ inputs, self, ... }:
{
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/master";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.default = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      backupCommand = "rmtrash";
      overwriteBackup = true;
    };
  };

  flake.modules.homeManager.default = {
    home = {
      stateVersion = self.const.stateVersion;
      shell = {
        enableFishIntegration = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
      };
    };

    programs.home-manager.enable = true;
  };
}
