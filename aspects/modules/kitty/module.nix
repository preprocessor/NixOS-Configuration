{
  perSystem =
    { pkgs, ... }:
    {
      remotePackages.kitty = pkgs.kitty.overrideAttrs (
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
      pkgs,
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

        fonts.packages = with pkgs; [
          maple-mono.variable
          maple-mono.NF
        ];

        hj.xdg.mime-apps.default-applications =
          [
            "inode/directory"
            "terminal"
            "x-terminal-emulator"
            "application/x-shellscript"
          ]
          |> map (mime: lib.nameValuePair mime [ "kitty.desktop" ])
          |> lib.listToAttrs;

        my.hyprland.startup =
          let
            cfg = config.my.kitty;
          in
          [
            ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:dev silent" })''
            ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:dev silent" })''
          ];

        my.hyprland.lua.files."keybinds.kitty".content = /* lua */ ''
          hl.bind("SUPER + Return", hl.dsp.exec_raw("kitty -1"), { release = true })

          hl.bind("SUPER + CTRL + Return", hl.dsp.exec_raw("kitty --class float-kitty"), { release = true, center = true })
        '';

        my.hyprland.windowrules.kitty = [
          {
            name = "float-kitty";
            match.class = "^float-kitty$";
            rules.float = true;
          }
        ];

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
          apply = lib.mapAttrs' (name: value: lib.nameValuePair ("map " + name) value);
        };

        extraCfg = mkOption {
          type = types.lines;
          default = "";
          description = "Additional configuration appended verbatim to kitty.conf.";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { files, ... }:
            {
              package = self'.packages.kitty;
              env.KITTY_CONFIG_DIRECTORY = files.config.dir;
              files.config = {
                relPath = "config/kitty.conf";
                file =
                  let
                    toKittyConfig = lib.generators.toKeyValue {
                      mkKeyValue =
                        key: value:
                        let
                          value' = value |> (if (lib.isBool value) then lib.boolToYesNo else toString);
                        in
                        "${key} ${value'}";
                    };
                  in
                  ''
                    # Settings
                    ${toKittyConfig cfg.settings}

                    # Keybindings
                    ${toKittyConfig cfg.keybindings}

                    # Theme
                    ${cfg.theme}

                    # extraCfg
                    ${cfg.extraCfg}
                  '';
              };
            }
          );
        };
      };
    };
}
