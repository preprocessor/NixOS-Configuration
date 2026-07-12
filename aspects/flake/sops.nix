{ inputs, rootPath, ... }:
{
  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default =
    {
      pkgs,
      config,
      constants,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      environment.systemPackages = [ pkgs.sops ];

      nix.extraOptions = "!include ${config.sops.secrets.nix_extra_config.path}";

      sops = {
        defaultSopsFile = rootPath + /.secrets/encrypted.yaml;
        age = {
          keyFile = "${config.hj.xdg.config.directory}/sops/age/keys.txt";
          generateKey = true;
        };
        secrets = {
          cachix_key.owner = constants.username;
          email1.owner = constants.username;
          nix_extra_config.owner = constants.username;
        };
      };
    };
}
