{
  flake.hjemModules.vesktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      json = pkgs.formats.json { };
      cfg = config.my.vesktop;
    in
    {
      options.my.vesktop = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "vesktop" { };

        settings = lib.mkOption {
          inherit (json) type;
          description = "Vesktop settings";
          default = { };
        };

        vencord.settings = lib.mkOption {
          inherit (json) type;
          default = { };
          description = "Vencord settings";
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            hj.packages = [ cfg.package ];

            hj.xdg.config.files = {
              "vesktop/settings.json".source = json.generate "vesktop-settings" cfg.settings;
              "vesktop/settings/settings.json".source = json.generate "vencord-settings" cfg.vencord.settings;
            };

            hj.xdg.mime-apps.default-applications = {
              "x-scheme-handler/discord" = [ "vesktop.desktop" ];
            };
          }

          (lib.mkIf config.my.hyprland.enable {
            my.hyprland.startup = [
              /* lua */ ''
                hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "3 silent" })
              ''
            ];

            my.hyprland.windowrules.vesktop = [
              {
                name = "hide vesktop";
                match.class = "^vesktop$";
                rules = {
                  workspace = "3 silent";
                  tag = "hidden";
                };
              }
            ];

            my.hyprland.lua.files."keybinds/vesktop".content = /* lua */ ''
              hl.bind("SUPER + F1", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "M", window = "class:(vesktop)" }))
            '';
          })
        ]
      );
    };

}
