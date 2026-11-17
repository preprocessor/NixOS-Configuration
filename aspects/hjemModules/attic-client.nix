{
  modules.core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.attic-client;

      toml = pkgs.formats.toml { };
    in
    {
      options.my.attic-client = {
        enable = lib.mkEnableOption "the attic binary cache client";

        package = lib.mkPackageOption pkgs "attic-client" {
          nullable = true;
        };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          example = lib.literalExpression ''
            {
              default-server = "myserver";
              servers.myserver = {
                endpoint = "https://myserver.org";
                token-file = "/run/secrets/attic-token";
              };
            }
          '';
          description = ''
            Configuration written to
            {file}`$XDG_CONFIG_HOME/attic/config.toml`.

            See <https://github.com/zhaofengli/attic> for the available options.
          '';
        };

        watchStore = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "mycacheserver:mycache" ];
          description = ''
            Caches to push new store paths to via `attic watch-store`.
            Format: `server:cache` (or just `cache` to use the default server).

            This relies on systemd and is only supported on Linux.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

        hj.xdg.config.files."attic/config.toml" = lib.mkIf (cfg.settings != { }) {
          source = toml.generate "attic-config.toml" cfg.settings;
        };

        hj.systemd.services = lib.mkIf (cfg.watchStore != [ ]) (
          lib.listToAttrs (
            map (
              cache:
              lib.nameValuePair "attic-watch-store--${lib.replaceStrings [ ":" ] [ "-" ] cache}" {
                Unit.Description = "Push new store paths to the attic cache ${cache}";

                Install.WantedBy = [ "default.target" ];

                Service = {
                  ExecStart = "${lib.getExe cfg.package} watch-store ${cache}";
                  Restart = "always";
                  RestartSec = 30;
                };
              }
            ) cfg.watchStore
          )
        );
      };
    };
}
