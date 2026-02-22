{
  inputs,
  config,
  pkgs,
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
