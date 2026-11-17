{ inputs, rootPath, ... }:
{
  tack.inputs.sops-nix = {
    url = "gh:Mic92/sops-nix";
    group = "nix";
  };

  modules.core =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      environment.systemPackages = [ pkgs.sops ];

      sops = {
        useSystemdActivation = true;
        age.keyFile = "${config.hj.xdg.config.directory}/sops/age/keys.txt";
      };
    };

  modules.host.ramiel = { constants, config, ... }: {
    sops.defaultSopsFile = rootPath + /.secrets/ramiel.yaml;

    nix.extraOptions = "!include ${config.sops.secrets.nix_extra_options.path}";

    sops.secrets = {
      cachix_key.owner = constants.username;
      email0.owner = constants.username;
      email1.owner = constants.username;
      github_access_token.owner = constants.username;
      nix_extra_options.owner = constants.username;
    };
  };

  modules.host.xyz = {
    sops.defaultSopsFile = rootPath + /.secrets/xyz.yaml;
    sops.secrets.harmonia_signing_key = { };
  };
}
