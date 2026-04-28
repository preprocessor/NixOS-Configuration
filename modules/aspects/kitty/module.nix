{ inputs, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      kitty =
        let
          go_1_26_2 = pkgs.go_1_26.overrideAttrs (
            finalAttrs: previousAttrs: {
              version = "1.26.2";
              src = pkgs.fetchurl {
                url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
                hash = "sha256-LpHrtpR6lulDb7KzkmqIAu/mOm03Xf/sT4Kqnb1v1Ds=";
              };
              doCheck = false;
              doInstallCheck = false;
            }
          );

          buildGo126Module = pkgs.buildGo126Module.override { go = go_1_26_2; };
        in
        (pkgs.kitty.override {
          buildGo126Module = buildGo126Module;
          go_1_26 = go_1_26_2;
        }).overrideAttrs
          (
            finalAttrs: previousAttrs: {
              pname = "kitty";
              version = "f42a5f89c3a17ef914b4e29168b70dc2fe59fb37";

              src = pkgs.fetchFromGitHub {
                owner = "kovidgoyal";
                repo = "kitty";
                rev = finalAttrs.version;
                hash = "sha256-m8QrxeqIlInoCaj/O7yLQ4Sh1MXTqoDgJVnk29FI5mk=";
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
    in
    {
      packages = { inherit kitty; };
    };
  w.desktop =
    { pkgs, config, ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          kitty = inputs.wrappers.wrappers.kitty.wrap (
            wrapper:
            let
              cfg = config.custom.programs.kitty;
            in
            {
              pkgs = prev;
              package = self.packages.${prev.stdenv.hostPlatform.system}.kitty;
              inherit (cfg) extraConfig keybindings;
              settings = cfg.settings // {
                include = wrapper.config.constructFiles.theme.path;
              };
              constructFiles.theme = {
                relPath = "oneshill.conf";
                content = cfg.theme;
              };
            }
          );
        })
      ];

      hj.packages = [ pkgs.kitty ];
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
