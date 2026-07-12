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

  w.desktop =
    { pkgs, config, ... }:
    {
      nixpkgs.overlays = [
        (_: prev: { kitty = config.my.kitty.package; })
      ];

      hj.packages = [ pkgs.kitty ];
    };

  w.default =
    {
      lib,
      pkgs,
      config,
      self',
      birdee,
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
    in
    {
      options.my.kitty = {
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

        package = lib.mkOption {
          default = birdee.wrappers.kitty.wrap (
            wrapper:
            let
              cfg = config.my.kitty;
            in
            {
              inherit pkgs;
              package = self'.packages.kitty;
              inherit (cfg) keybindings;
              extraConfig = cfg.extraCfg;
              settings = cfg.settings // {
                include = wrapper.config.constructFiles.theme.path;
              };
              constructFiles.theme = {
                relPath = "oneshill.conf";
                content = cfg.theme;
              };
            }
          );
        };

        extraCfg = mkOption {
          type = types.lines;
          default = "";
          description = "Additional configuration appended verbatim to kitty.conf.";
        };
      };
    };
}
