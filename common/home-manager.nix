{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = { inherit inputs; };

    users.wyspr = {
      imports = [
        inputs.nix-index-database.homeModules.default
        inputs.nixcord.homeModules.nixcord
        inputs.direnv-instant.homeModules.direnv-instant
        ../home # /default.nix
      ];

      home = {
        stateVersion = config.system.stateVersion; # Match NixOS version
        shell = {
          enableFishIntegration = true;
          enableBashIntegration = true;
          enableNushellIntegration = true;
        };
      };
    };
  };
}
