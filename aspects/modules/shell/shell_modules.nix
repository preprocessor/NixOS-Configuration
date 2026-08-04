{
  exo.skeleton =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) types;
    in
    {
      options = {
        my.xdg.desktopTuiEntries = lib.mkOption {
          description = "Custom Desktop Entries";
          default = { };
          type = types.attrsOf (
            types.submodule {
              options = {
                package = lib.mkOption {
                  type = types.package;
                };

                width = lib.mkOption {
                  type = types.number;
                };

                height = lib.mkOption {
                  type = types.number;
                };
              };
            }
          );
        };
      };

      config =
        let
          cfg = config.my.xdg.desktopTuiEntries;
        in
        lib.mkIf (cfg != { }) {
          my.xdg.desktopEntries =
            cfg
            |> lib.mapAttrs' (
              name: value: {
                name = (name |> lib.replaceStrings [ " " ] [ "_" ]);
                value = {
                  inherit name;
                  icon = "kitty";
                  exec = ''hyprctl dispatch "hl.dsp.exec_cmd('kitty --class ${name} -e ${lib.getExe value.package}', {size = {${toString value.width}, ${toString value.height}}, float = true, center = true})"'';
                };
              }
            );
        };

      _file = ./shell_modules.nix;
    };
}
