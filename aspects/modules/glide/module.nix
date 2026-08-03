{
  tack = {
    glide-browser.url = "gh:glide-browser/glide.nix";
    textfox.url = "gh:adriankarlen/textfox";
  };

  exo.skeleton =
    {
      packages',
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.glide-browser;
      iniFormat = lib.generators.toINI { };

      mkTextfoxCss =
        tf:
        let
          boolToDisplay = b: if b then "flex" else "none";
        in
        ''
          :root {
            --tf-font-family: ${tf.font.family};
            --tf-font-size: ${tf.font.size};
            --tf-accent: ${tf.font.accent};
            --tf-bg: ${tf.background.color};
            --tf-border: ${tf.border.color};
            --tf-border-transition: ${tf.border.transition};
            --tf-border-width: ${tf.border.width};
            --tf-rounding: ${tf.border.radius};
            --tf-text-transform: ${tf.textTransform};
            --tf-display-horizontal-tabs: ${if tf.tabs.horizontal.enable then "block" else "none"};
            --tf-display-window-controls: ${boolToDisplay tf.displayWindowControls};
            --tf-display-nav-buttons: ${boolToDisplay tf.displayNavButtons};
            --tf-display-urlbar-icons: ${boolToDisplay tf.displayUrlbarIcons};
            --tf-display-sidebar-tools: ${boolToDisplay tf.displaySidebarTools};
            --tf-display-titles: ${boolToDisplay tf.displayTitles};
            --tf-newtab-logo: "${tf.newtabLogo}";
            --tf-navbar-margin: ${tf.navbar.margin};
            --tf-navbar-padding: ${tf.navbar.padding};
            --tf-bookmarks-alignment: ${tf.bookmarks.alignment};
          }
          ${tf.extraConfig}
        '';
    in
    {
      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
        hj.xdg.config.files = lib.mkIf (cfg.profiles != { }) (
          lib.mergeAttrsList [
            # 1. profiles.ini
            {
              "glide/glide/profiles.ini".text = iniFormat (
                {
                  General.StartWithLastProfile = 1;
                  Install.Default =
                    (lib.findFirst (p: p.isDefault) (lib.head (lib.attrValues cfg.profiles)) (
                      lib.attrValues cfg.profiles
                    )).path;
                }
                // (
                  cfg.profiles
                  |> lib.attrNames
                  |> lib.imap0 (
                    i: name:
                    lib.nameValuePair "Profile${toString i}" {
                      Name = name;
                      IsRelative = 1;
                      Path = cfg.profiles.${name}.path;
                    }
                  )
                  |> lib.listToAttrs
                )
              );
            }

            # 2. userJsFiles
            (
              cfg.profiles
              |> lib.mapAttrs' (
                name: profile:
                lib.nameValuePair "glide/glide/${profile.path}/user.js" {
                  text =
                    (
                      profile.settings
                      |> lib.mapAttrsToList (name: value: ''user_pref("${name}", ${lib.toJSON value});'')
                      |> lib.concatStringsSep "\n"
                    )
                    + "\n"
                    + lib.optionalString profile.textfox.enable (
                      let
                        toBoolStr = b: if b then "true" else "false";
                      in
                      ''
                        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
                        user_pref("svg.context-properties.content.enabled", true);
                        user_pref("layout.css.has-selector.enabled", true);
                        user_pref("shyfox.enable.ext.mono.toolbar.icons", ${toBoolStr profile.textfox.icons.toolbar.extensions.enable});
                        user_pref("shyfox.enable.ext.mono.context.icons", ${toBoolStr profile.textfox.icons.context.extensions.enable});
                        user_pref("shyfox.enable.context.menu.icons", ${toBoolStr profile.textfox.icons.context.firefox.enable});
                        user_pref("sidebar.revamp", ${toBoolStr profile.textfox.tabs.vertical.enable});
                        user_pref("sidebar.verticalTabs", ${toBoolStr profile.textfox.tabs.vertical.enable});
                      ''
                    );
                }
              )
            )

            # 3. textfox chrome
            (
              cfg.profiles
              |> lib.filterAttrs (_: profile: profile.textfox.enable)
              |> lib.mapAttrsToList (
                name: profile: {
                  "glide/glide/${profile.path}/chrome".source = pkgs.runCommand "glide-textfox-chrome" { } ''
                    mkdir -p $out
                    cp -r --no-preserve=mode ${packages'.textfox.default}/chrome/* $out/
                    install -m 644 ${pkgs.writeText "config.css" (mkTextfoxCss profile.textfox)} $out/config.css
                  '';
                }
              )
              |> lib.mergeAttrsList
            )
          ]
        );

        xdg.mime = lib.mkIf cfg.setAsDefaultBrowser {
          defaultApplications =
            [
              "application/x-extension-shtml"
              "application/x-extension-xhtml"
              "application/x-extension-html"
              "application/x-extension-xht"
              "application/x-extension-htm"
              "x-scheme-handler/unknown"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "application/xhtml+xml"
              "application/json"
              "application/pdf"
              "text/html"
            ]
            |> map (mime: lib.nameValuePair mime [ "glide.desktop" ])
            |> lib.listToAttrs;
        };
        hj.environment.sessionVariables = lib.mkIf cfg.setAsDefaultBrowser { BROWSER = "glide"; };

        my.hyprland.lua.files."window-rules.spotify" = /* lua */ ''
          hl.window_rule({
            name      = "glide-glide",
            match     = { class = "glide-glide" },
            fullscreen_state = "0 3";
          })
        '';
      };
      options.my.glide-browser = {
        enable = lib.mkEnableOption "glide-browser";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.wrapFirefox packages'.glide-browser.glide-browser-bin-unwrapped {
            extraPolicies = cfg.policies;
            inherit (cfg) nativeMessagingHosts;
          };
          description = "The package to use.";
        };

        policies = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Glide Browser policies.";
        };

        nativeMessagingHosts = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Native messaging hosts.";
        };

        setAsDefaultBrowser = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set Glide Browser as default browser.";
        };

        profiles = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, ... }:
              {
                options = {
                  path = lib.mkOption {
                    type = lib.types.str;
                    default = name;
                    description = "Profile directory name.";
                  };

                  isDefault = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = "Whether this is the default profile.";
                  };

                  settings = lib.mkOption {
                    type = lib.types.attrs;
                    default = { };
                    description = "Profile settings (written to user.js).";
                  };

                  textfox = {
                    enable = lib.mkEnableOption "textfox theme";

                    displayWindowControls = lib.mkEnableOption "window controls";
                    displayNavButtons = lib.mkEnableOption "back and forward navigation buttons in the Firefox UI";
                    displayUrlbarIcons = lib.mkEnableOption "icons inside url bar";

                    displaySidebarTools = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                    };

                    displayTitles = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                    };

                    newtabLogo = lib.mkOption {
                      type = lib.types.str;
                      default = ''
                           __            __  ____
                          / /____  _  __/ /_/ __/___  _  __
                         / __/ _ \| |/ / __/ /_/ __ \| |/ /
                        / /_/  __/>  </ /_/ __/ /_/ />  <
                        \__/\___/_/|_|\__/_/  \____/_/|_|
                      '';
                      apply = p: lib.replaceStrings [ "\n" "\\" ] [ "\\A" "\\\\" ] p;
                    };

                    background.color = lib.mkOption {
                      type = lib.types.str;
                      default = "var(--lwt-accent-color, -moz-dialog)";
                    };

                    font = {
                      family = lib.mkOption {
                        type = lib.types.str;
                        default = "\"SF Mono\", Consolas, monospace";
                      };
                      size = lib.mkOption {
                        type = lib.types.str;
                        default = "14px";
                      };
                      accent = lib.mkOption {
                        type = lib.types.str;
                        default = "var(--toolbarbutton-icon-fill)";
                      };
                    };

                    border = {
                      color = lib.mkOption {
                        type = lib.types.str;
                        default = "var(--panel-border-color, --toolbar-field-background-color)";
                      };
                      transition = lib.mkOption {
                        type = lib.types.str;
                        default = "0.2s ease";
                      };
                      width = lib.mkOption {
                        type = lib.types.str;
                        default = "2px";
                      };
                      radius = lib.mkOption {
                        type = lib.types.str;
                        default = "0px";
                      };
                    };

                    icons = {
                      toolbar.extensions.enable = lib.mkEnableOption "monochrome extension toolbar buttons";
                      context.extensions.enable = lib.mkEnableOption "monochrome extension context menu items";
                      context.firefox.enable = lib.mkEnableOption "icons for common context menu items";
                    };

                    tabs = {
                      horizontal.enable = lib.mkEnableOption "display of horizontal tabs";
                      vertical.enable = lib.mkEnableOption "display of vertical tabs";
                    };

                    extraConfig = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                    };
                    textTransform = lib.mkOption {
                      type = lib.types.str;
                      default = "none";
                    };

                    navbar = {
                      margin = lib.mkOption {
                        type = lib.types.str;
                        default = "8px 8px 2px";
                      };
                      padding = lib.mkOption {
                        type = lib.types.str;
                        default = "4px";
                      };
                    };

                    bookmarks.alignment = lib.mkOption {
                      type = lib.types.str;
                      default = "center";
                    };
                  };
                };
              }
            )
          );
        };
      };
    };
}
