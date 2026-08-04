{
  exo.mods.desktop =
    { scheme, ... }:
    {
      my.fuzzel = {
        enable = true;

        settings = {
          main = {
            launch-prefix = "app2unit --";
            namespace = "fuzzel";
            render-workers = 10;
            match-workers = 10;
            horizontal-pad = 10;
            vertical-pad = 10;
            prompt = ''"Run: "'';
            font = "SF Pro Display:weight=Medium:size=16";
          };
          colors = with scheme; {
            background = "${base11}e5";
            text = "${base05}ff";
            match = "${bright-magenta}ff";
            selection-match = "${bright-magenta}ff";
            selection = "${base00}ff";
            selection-text = "${bright-cyan}ff";
            border = "${bright-cyan}ff";
          };
          border = {
            radius = 0;
            selection-radius = 0;
          };
        };
      };
    };

  exo.skeleton =
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
            { wlib, ... }:
            {
              package = pkgs.fuzzel;
              args = [ "--config=${wlib.files}/fuzzel.ini" ];
              files =
                "fuzzel.ini"
                |> wlib.buildAndAppend' {
                  formatter = ini;
                  buildFrom = cfg.settings;
                  appendString = "";
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

      _file = ./module.nix;
    };
}
