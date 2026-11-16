{
  modules.core = 
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      json = pkgs.formats.json { };
      cfg = config.my.equibop;
    in
    {
      options.my.equibop = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "equibop" { };

        settings = lib.mkOption {
          inherit (json) type;
          description = "equibop settings";
          default = { };
        };

        equicord.settings = lib.mkOption {
          inherit (json) type;
          default = { };
          description = "equicord settings";
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            hj.packages = [ cfg.package ];

            hj.xdg.config.files = {
              "equibop/settings.json".source = json.generate "equibop-settings" cfg.settings;
              "equibop/settings/settings.json".source = json.generate "equicord-settings" cfg.equicord.settings;
            };

            hj.xdg.mime-apps.default-applications = {
              "x-scheme-handler/discord" = [ "equibop.desktop" ];
            };
          }

          (lib.mkIf config.my.hyprland.enable {
            my.hyprland.startup = [
              /* lua */ ''
                hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "3 silent" })
              ''
            ];

            my.hyprland.windowrules.equibop = [
              {
                name = "hide equibop";
                match.class = "^equibop$";
                rules = {
                  workspace = "3 silent";
                  tag = "hidden";
                };
              }
            ];

            my.hyprland.lua.files."keybinds/equibop".content = /* lua */ ''
              hl.bind("SUPER + F1", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "M", window = "class:(equibop)" }))
            '';
          })
        ]
      );
    };

}
