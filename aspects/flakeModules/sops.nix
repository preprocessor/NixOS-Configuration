{ inputs, rootPath, ... }:
{
  tack.inputs.sops-nix = {
    url = "gh:Mic92/sops-nix";
    group = "nix";
  };

  modules.core =
    {
      constants,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      environment.systemPackages = [ pkgs.sops ];

      nix.extraOptions = "!include ${config.sops.secrets.nix_extra_options.path}";

      sops = {
        useSystemdActivation = true;
        age.generateKey = true;
        secrets = {
          cachix_key.owner = constants.username;
          email0.owner = constants.username;
          email1.owner = constants.username;
          github_access_token.owner = constants.username;
          nix_extra_options.owner = constants.username;
        };
      };
    };

  modules.host.ramiel = { config, ... }: {
    sops.age.keyFile = "${config.hj.xdg.config.directory}/sops/age/keys.txt";
    sops.defaultSopsFile = rootPath + /.secrets/ramiel.yaml;
  };
}
