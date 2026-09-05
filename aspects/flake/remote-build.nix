{
  perSystem =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.remotePackages = lib.mkOption {
        type = with lib.types; lazyAttrsOf package;
        default = { };
      };

      config = {
        packages = config.remotePackages;
        apps.list-remote-packages = {
          type = "app";
          meta.description = "List packages that will be built remotely (to be used in a Github Action)";
          program =
            (pkgs.writeShellScript "list-remote-packages" ''
              echo '${config.remotePackages |> lib.attrNames |> lib.concatLines |> lib.trim}'
            '').outPath;
        };
      };
    };

  exo.core = {
    nix.settings = {
      extra-substituters = [ "https://bazinga.cachix.org" ];
      extra-trusted-public-keys = [ "bazinga.cachix.org-1:WI9TV6l0gBVhcfY7OQM5zWqYmESIarKME0fjVN6yDYU=" ];
    };
  };
}
