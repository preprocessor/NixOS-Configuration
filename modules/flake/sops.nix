{ inputs, self, ... }:
{
  ff.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default =
    { pkgs, config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      environment.systemPackages = [ pkgs.sops ];
      sops = {
        age = {
          keyFile = "${config.hj.xdg.config.directory}/sops/age/keys.txt";
          generateKey = true;
        };
        secrets.private_key = {
          key = "private_key";
          owner = self.const.username;
          format = "yaml";
          sopsFile = ../../secrets/cachix.yaml;
        };
      };
    };
}
