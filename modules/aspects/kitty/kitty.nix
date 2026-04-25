{ inputs, ... }:
{
  w.desktop =
    { pkgs, config, ... }:
    let
      cfg = config.custom.programs.kitty;

      mkKittyLatest =
        prev:
        let
          go_1_26_2 = prev.go_1_26.overrideAttrs (
            finalAttrs: previousAttrs: {
              version = "1.26.2";
              src = prev.fetchurl {
                url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
                hash = "sha256-LpHrtpR6lulDb7KzkmqIAu/mOm03Xf/sT4Kqnb1v1Ds=";
              };
              doCheck = false;
              doInstallCheck = false;
            }
          );

          buildGo126Module = prev.buildGo126Module.override { go = go_1_26_2; };
        in
        (prev.kitty.override {
          buildGo126Module = buildGo126Module;
          go_1_26 = go_1_26_2;
        }).overrideAttrs
          (
            finalAttrs: previousAttrs: {
              pname = "kitty";
              version = "cadaec5712de8583be1409dff6c9a3967f1e4ab4";

              src = prev.fetchFromGitHub {
                owner = "kovidgoyal";
                repo = "kitty";
                rev = finalAttrs.version;
                hash = "sha256-A+0vyWiNA4OcmhVEAE3lNOKG5i89tADnLWV64rN39nM=";
              };

              pyproject = false;
              doCheck = false;
              dontCheck = true;
              checkPhase = "true";
              installCheckPhase = "true";

              goModules =
                (buildGo126Module {
                  pname = "kitty-go-modules";
                  src = finalAttrs.src;
                  version = finalAttrs.version;
                  vendorHash = "sha256-jkWijMZrDapttSOrOjKuXLzZI+Lp6BhS1jWbMHJbniI=";
                }).goModules;
            }
          );

      kitty = inputs.wrappers.wrappers.kitty.wrap (
        { config, ... }:
        {
          inherit pkgs;
          package = mkKittyLatest pkgs;
          inherit (cfg) extraConfig keybindings;
          settings = cfg.settings // {
            include = config.constructFiles.theme.path;
          };
          constructFiles.theme = {
            relPath = "theme.conf";
            content = cfg.theme;
          };
        }
      );
    in
    {
      hj.packages = [ kitty ];

      custom.programs.kitty = {
        settings = {
          text_composition_strategy = "legacy";
          font_family = ''family="Maple Mono NF" style="Medium"'';
          bold_font = ''family="Maple Mono NF" style="ExtraBold"'';
          italic_font = ''family="Maple Mono NF" style="Italic"'';
          bold_italic_font = ''family="Maple Mono NF" style="ExtraBold Italic"'';
          font_size = "14";

          disable_ligatures = "cursor";

          wayland_enable_ime = "no";

          sync_to_monitor = "yes";
          remember_window_position = "no";

          draw_minimal_borders = "yes";
          placement_strategy = "center";
          update_check_interval = "24";
          allow_hyperlinks = "yes";

          scrollback_lines = "10000";
          wheel_scroll_multiplier = "5.0";

          strip_trailing_spaces = "smart";
          hide_window_decorations = "yes";

          enable_audio_bell = "no";
          visual_bell_duration = "0.0";
          repaint_delay = "10";

          confirm_os_window_close = "0";

          cursor_trail = "1";
          cursor_trail_decay = "0.1 0.2";
          cursor_shape = "block";
          cursor_blink_interval = "0.5";
          cursor_stop_blinking_after = "15.0";
          enabled_layouts = "splits,stack";

          # Better URL handling
          detect_urls = "yes";
          url_style = "curly";
          # Match foot's "hide cursor when typing"
          mouse_hide_wait = "2.0";

          # Match foot's hollow cursor when unfocused
          focus_follows_mouse = "no"; # if you don't already have FFM
          cursor_shape_unfocused = "hollow"; # kitty 0.36+
        };

        keybindings = {
          # Splits
          "ctrl+a>p>d" = "launch --location=hsplit";
          "ctrl+a>p>n" = "launch --location=vsplit";
          "ctrl+n" = "launch --location=vsplit";
          # Navigation with Alt + arrows
          "alt+left" = "neighboring_window left";
          "alt+right" = "neighboring_window right";
          "alt+up" = "neighboring_window up";
          "alt+down" = "neighboring_window down";

          "ctrl+x" = "close_window";
        };

        extraConfig = /* toml */ ''
          font_features MapleMono-NF-Bold +cv01 +cv02 +cv03 +cv06 +cv07 +cv08 +cv09 +cv10 +cv39 +cv40 +cv42 +cv43 +cv66 +ss03 +ss07 +ss08 +ss09 +ss10 +ss11 +calt
          font_features MapleMono-NF-ExtraBold +cv01 +cv02 +cv03 +cv06 +cv07 +cv08 +cv09 +cv10 +cv39 +cv40 +cv42 +cv43 +cv66 +ss03 +ss07 +ss08 +ss09 +ss10 +ss11 +zero +calt
          font_features MapleMono-NF-BoldItalic +cv01 +cv02 +cv03 +cv06 +cv07 +cv08 +cv09 +cv10 +cv39 +cv40 +cv42 +cv43 +cv66 +ss03 +ss07 +ss08 +ss09 +ss10 +ss11 +zero +calt
          font_features MapleMono-NF-ExtraBoldItalic +cv01 +cv02 +cv03 +cv06 +cv07 +cv08 +cv09 +cv10 +cv39 +cv40 +cv42 +cv43 +cv66 +ss03 +ss07 +ss08 +ss09 +ss10 +ss11 +zero +calt
          mouse_map right press ungrabbed combine : copy_to_clipboard : clear_selection
          mouse_map left press ungrabbed mouse_selection drag_or_normal_select
        '';
      };
    };

  w.default =
    { lib, ... }:
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
      options.custom.programs.kitty = {
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

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Additional configuration appended verbatim to kitty.conf.";
        };
      };
    };
}
