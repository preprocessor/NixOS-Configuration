{ lib, ... }:
{
  w.desktop =
    { pkgs, ... }:
    {
      custom.services.udiskie = {
        enable = true;
        settings = {
          program_options = {
            file_manager = "${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.yazi}";
          };
        };
      };
    };

  w.default =
    { pkgs, config, ... }:
    let
      inherit (lib) mkOption types;

      mergeSets = sets: lib.lists.foldr lib.attrsets.recursiveUpdate { } sets;

      yaml = pkgs.formats.yaml { };

      cfg = config.custom.services.udiskie;
    in
    {
      options.custom.services.udiskie = {
        enable = lib.mkEnableOption "" // {
          description = ''
            Whether to enable the udiskie mount daemon.

            Note, if you use NixOS then you must add
            `services.udisks2.enable = true`
            to your system configuration. Otherwise mounting will fail because
            the Udisk2 DBus service is not found.
          '';
        };

        package = lib.mkPackageOption pkgs "udiskie" { };

        settings = mkOption {
          inherit (yaml) type;
          default = { };
          example = lib.literalExpression ''
            {
              program_options = {
                udisks_version = 2;
                tray = true;
              };
              icon_names.media = [ "media-optical" ];
            }
          '';
          description = ''
            Configuration written to
            {file}`$XDG_CONFIG_HOME/udiskie/config.yml`.

            See <https://github.com/coldfix/udiskie/blob/master/doc/udiskie.8.txt#configuration>
            for the full list of options.
          '';
        };

        automount = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to automatically mount new devices.";
        };

        notify = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to show pop-up notifications.";
        };

        tray = mkOption {
          type = types.enum [
            "always"
            "auto"
            "never"
          ];
          default = "never";
          description = ''
            Whether to display tray icon.

            The options are

            `always`
            : Always show tray icon.

            `auto`
            : Show tray icon only when there is a device available.

            `never`
            : Never show tray icon.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        services.udisks2.enable = true;

        hj.xdg.config.files."udiskie/config.yml".source = yaml.generate "udiskie-config.yml" (mergeSets [
          {
            program_options = {
              inherit (cfg) automount;
              tray =
                if cfg.tray == "always" then
                  true
                else if cfg.tray == "never" then
                  false
                else
                  "auto";
              inherit (cfg) notify;
            };
          }
          cfg.settings
        ]);

        hj.systemd.services.udiskie = {
          description = "udiskie mount daemon";
          requires = lib.optional (cfg.tray != "never") "tray.target";
          after = [ "graphical-session.target" ] ++ lib.optional (cfg.tray != "never") "tray.target";
          partOf = [ "graphical-session.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = lib.getExe' cfg.package "udiskie";
            # ExecStart = toString ([ (lib.getExe' cfg.package "udiskie") ]
            #   # ++ lib.optional config.xsession.preferStatusNotifierItems "--appindicator"
            # );
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };

          wantedBy = [ "graphical-session.target" ];
        };
      };
    };

}
