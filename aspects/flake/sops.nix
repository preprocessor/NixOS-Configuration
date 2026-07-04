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
      sops = {
        defaultSopsFile = rootPath + /.secrets/encrypted.yaml;
        age = {
          keyFile = "${config.hj.xdg.config.directory}/sops/age/keys.txt";
          generateKey = true;
        };
        secrets = {
          cachix_key.owner = constants.username;
          email1.owner = constants.username;
        };
      };
    };
}
