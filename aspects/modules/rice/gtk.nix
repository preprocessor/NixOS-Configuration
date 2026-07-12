{
  w.default =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.my.gtk;

      default_index_theme = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${cfg.cursor.name}
      '';
    in
    {
      config = lib.mkIf (cfg.enable) {
        hj.packages = [
          cfg.theme.package
          cfg.cursor.package
        ];

        hj.environment.sessionVariables = {
          XCURSOR_SIZE = cfg.cursor.size;
          XCURSOR_THEME = cfg.cursor.name;
        };

        hj.xdg.data.files = {
          "icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";
          "icons/default/index.theme".text = default_index_theme;
        };

        hj.files = {
          ".icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";
          ".icons/default/index.theme".text = default_index_theme;
        };

        programs.dconf = {
          enable = true;

          profiles.user.databases = [
            {
              settings = {
                "ca/desrt/dconf-editor".show-warning = false; # disable dconf first use warning
                # gtk related settings
                "org/gnome/desktop/interface" = with cfg; {
                  gtk-theme = theme.name;
                  icon-theme = icons.name;
                  cursor-theme = cursor.name;
                  cursor-size = cursor.size;
                  font-name = "${fonts.sans.name} ${fonts.sans.size}";
                  document-font-name = "${fonts.serif.name} ${fonts.serif.size}";
                  monospace-font-name = "${fonts.mono.name} ${fonts.mono.size}";
                  color-scheme = "prefer-dark"; # set dark theme for gtk 4
                  # disable middle click paste
                  gtk-enable-primary-paste = false;
                  font-antialiasing = "rgba";
                  font-hinting = "full";
                  text-scaling-factor = 1.0;
                  overlay-scrolling = false;
                };
              };
            }
          ];
        };

        gtk.iconCache.enable = true;

        fonts = {
          fontDir.enable = true;

          fontconfig = {
            enable = true;
            antialias = true;
            hinting = {
              enable = true;
              style = "full";
              autohint = false;
            };
            subpixel = {
              rgba = "rgb";
              lcdfilter = "light";
            };
            defaultFonts = with cfg.fonts; {
              serif = [ serif.name ];
              sansSerif = [ sans.name ];
              monospace = [ mono.name ];
              emoji = [ emoji.name ];
            };
          };

          packages =
            with cfg.fonts;
            [
              serif.package
              sans.package
              mono.package
              emoji.package
            ]
            ++ (with pkgs; [
              # Default packages from: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/fonts/packages.nix
              corefonts
              freefont_ttf
              vista-fonts-chs # Chinese
              gyre-fonts # TrueType substitutes for standard PostScript fonts
              liberation_ttf
              unifont
            ]);
        };
      };

      options.my.gtk = {
        enable = lib.mkEnableOption { };

        theme = {
          name = lib.mkOption {
            description = "GTK Theme";
            type = lib.types.str;
            default = "Adwaita";
          };

          css = lib.mkOption {
            type = with lib.types; nullOr lines;
            default = null;
            description = "Raw css content";
          };

          package = lib.mkOption {
            description = "GTK Theme package";
            type = lib.types.nullOr lib.types.package;
            default = null;
          };
        };

        icons = {
          name = lib.mkOption {
            description = "GTK Icon theme";
            type = lib.types.str;
            default = "Adwaita";
          };

          package = lib.mkOption {
            description = "GTK Icon theme package";
            type = lib.types.nullOr lib.types.package;
            default = pkgs.adwaita-icon-theme;
          };
        };

        cursor = {
          name = lib.mkOption {
            description = "Cursor theme";
            type = lib.types.str;
            default = "Adwaita";
          };

          size = lib.mkOption {
            description = "Cursor size";
            type = lib.types.int;
            default = 32;
            apply = toString;
          };

          package = lib.mkOption {
            description = "Cursor theme package";
            type = lib.types.nullOr lib.types.package;
            default = pkgs.adwaita-icon-theme;
          };
        };

        fonts = {
          serif = {
            name = lib.mkOption {
              description = "Font name";
              type = lib.types.str;
              default = "DejaVu Serif";
            };

            size = lib.mkOption {
              description = "Font size";
              type = lib.types.int;
              default = 12;
              apply = toString;
            };

            package = lib.mkOption {
              description = "Font package";
              type = lib.types.package;
              default = pkgs.dejavu_fonts;
            };
          };

          sans = {
            name = lib.mkOption {
              description = "Font name";
              type = lib.types.str;
              default = "DejaVu Sans";
            };

            size = lib.mkOption {
              description = "Font size";
              type = lib.types.int;
              default = 12;
              apply = toString;
            };

            package = lib.mkOption {
              description = "Font package";
              type = lib.types.package;
              default = pkgs.dejavu_fonts;
            };
          };

          mono = {
            name = lib.mkOption {
              description = "Font name";
              type = lib.types.str;
              default = "DejaVu Sans Mono";
            };

            size = lib.mkOption {
              description = "Font size";
              type = lib.types.int;
              default = 12;
              apply = toString;
            };

            package = lib.mkOption {
              description = "Font package";
              type = lib.types.package;
              default = pkgs.dejavu_fonts;
            };
          };

          emoji = {
            name = lib.mkOption {
              description = "Font name";
              type = lib.types.str;
              default = "Noto Color Emoji";
            };

            size = lib.mkOption {
              description = "Font size";
              type = lib.types.int;
              default = 12;
              apply = toString;
            };

            package = lib.mkOption {
              description = "Font package";
              type = lib.types.package;
              default = pkgs.noto-fonts-color-emoji;
            };
          };
        };
      };

      _file = ./gtk.nix;
    };
}
