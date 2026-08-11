{ inputs, rootPath, ... }:
{
  tack.inputs.sops-nix.url = "gh:Mic92/sops-nix";

  exo.core =
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
        defaultSopsFile = rootPath + /.secrets/encrypted.yaml;
        useSystemdActivation = true;
        age = {
          keyFile = "${config.hj.xdg.config.directory}/sops/age/keys.txt";
          generateKey = true;
        };
        secrets = {
          cachix_key.owner = constants.username;
          email0.owner = constants.username;
          email1.owner = constants.username;
          github_access_token.owner = constants.username;
          nix_extra_options.owner = constants.username;
        };
      };
    };
}
