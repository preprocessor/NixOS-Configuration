{
  perSystem =
    { pkgs, ... }:
    {
      packages.kitty = pkgs.kitty.overrideAttrs (
        finalAttrs: previousAttrs: {
          patches = (previousAttrs.patches or [ ]) ++ [ ./shade-blocks.patch ];
          doCheck = false;
        }
      );
    };

  exo.skeleton =
    {
      wrapPackage,
      config,
      self',
      lib,
      ...
    }:
    let
      inherit (lib)
        types
        mkOption
        literalExpression
        ;

      settingsValueType =
        with types;
        oneOf [
          str
          bool
          int
          float
        ];
      cfg = config.my.kitty;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];
      };

      options.my.kitty = {
        enable = lib.mkEnableOption { };

        settings = mkOption {
          type = types.attrsOf settingsValueType;
          default = { };
          example = literalExpression ''
            {
              scrollback_lines = 10000;
              enable_audio_bell = false;
              update_check_interval = 0;
            }
          '';
          description = ''
            Key/value pairs written into `kitty.conf`.
            See <https://sw.kovidgoyal.net/kitty/conf.html>.
          '';
        };
        theme = mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = ''
            Color scheme for kitty
          '';
        };

        keybindings = mkOption {
          type = types.attrsOf types.str;
          default = { };
          example = literalExpression ''
            {
              "ctrl+c" = "copy_or_interrupt";
              "ctrl+f>2" = "set_font_size 20";
            }
          '';
          description = "Mapping of keybindings to actions.";
        };

        extraCfg = mkOption {
          type = types.lines;
          default = "";
          description = "Additional configuration appended verbatim to kitty.conf.";
        };

        package = lib.mkOption {
          default =
            let
              cfg = config.my.kitty;
              toKittyConfig = lib.generators.toKeyValue {
                mkKeyValue =
                  key: value:
                  let
                    yesNo = v: if v then "yes" else "no";
                    value' = value |> (if (builtins.isBool value) then yesNo else toString);
                  in
                  "${key} ${value'}";
              };
            in
            wrapPackage (
              { wlib, ... }:
              {
                package = self'.packages.kitty;
                env.KITTY_CONFIG_DIRECTORY = wlib.files;
                files = {
                  "kitty.conf" = ''
                    ${toKittyConfig cfg.settings}

                    # Keybindings
                    ${toKittyConfig cfg.keybindings}

                    # extraCfg
                    ${cfg.extraCfg}

                    # Theme
                    ${cfg.theme}
                  '';
                };
              }
            );
        };
      };
    };
}
