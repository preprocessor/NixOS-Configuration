{
  flake.hjemModules.fuzzel =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.fuzzel;
      ini = pkgs.formats.ini { };
    in
    {
      options.my.fuzzel = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (ini) type;
          default = { };
          description = "Options to go into fuzzel's ini config";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { wlib, files, ... }:
            {
              package = pkgs.fuzzel;
              args = [ "--config=${files.cfg}" ];
              files.cfg = {
                path = "config/fuzzel.ini";
                file = wlib.ini "fuzzel.ini" cfg.settings;
              };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        my.hyprland.lua.files = {
          "layer_rules.fuzzel".content = /* lua */ ''
            hl.layer_rule({
              match = { namespace = "^fuzzel$" },
              blur = true,
            })
          '';

          "keybinds.fuzzel".content = /* lua */ ''
            hl.bind("SUPER + Space", function()
              local fuzzel_open = false

              for _, value in pairs(hl.get_layers()) do
                if value.namespace == "fuzzel" then
                  fuzzel_open = true
                  break
                end
              end

              if fuzzel_open then
                hl.dispatch(hl.dsp.exec_raw("pkill fuzzel"))
              else
                hl.dispatch(hl.dsp.exec_raw("fuzzel"))
              end
            end)
          '';
        };
      };
    };
}
